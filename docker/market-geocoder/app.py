import os
import re
from functools import lru_cache
from typing import Optional

import requests
from fastapi import FastAPI
from geopy.geocoders import Nominatim
from pydantic import BaseModel, ConfigDict


app = FastAPI(title="Financeiro Market Geocoder")


class GeocodeLookupRequest(BaseModel):
    postal_code: Optional[str] = None
    state: Optional[str] = None
    city: Optional[str] = None
    neighborhood: Optional[str] = None
    address: Optional[str] = None

    model_config = ConfigDict(str_strip_whitespace=True)


class GeocodeLookupResponse(BaseModel):
    city: Optional[str] = None
    state: Optional[str] = None
    neighborhood: Optional[str] = None
    postal_code: Optional[str] = None
    address: Optional[str] = None
    latitude: Optional[str] = None
    longitude: Optional[str] = None
    source: str


@lru_cache(maxsize=1)
def get_geolocator() -> Nominatim:
    user_agent = os.getenv("MARKET_GEOCODER_USER_AGENT", "FinanceiroMarket/1.0 (dev@localhost)")
    timeout = int(os.getenv("MARKET_GEOCODER_NOMINATIM_TIMEOUT", "15"))
    return Nominatim(user_agent=user_agent, timeout=timeout)


@app.get("/up")
def up() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/v1/geocode/lookup", response_model=GeocodeLookupResponse)
def geocode_lookup(payload: GeocodeLookupRequest) -> GeocodeLookupResponse:
    postal_code = normalize_postal_code(payload.postal_code)
    viacep_data = fetch_viacep_address(postal_code) if postal_code else None

    merged = {
        "postal_code": postal_code or (normalize_postal_code(viacep_data.get("cep")) if viacep_data else None),
        "state": first_non_empty(payload.state, viacep_data.get("uf") if viacep_data else None),
        "city": first_non_empty(payload.city, viacep_data.get("localidade") if viacep_data else None),
        "neighborhood": first_non_empty(payload.neighborhood, viacep_data.get("bairro") if viacep_data else None),
        "address": first_non_empty(payload.address, viacep_data.get("logradouro") if viacep_data else None),
    }

    query = build_query(merged)
    if query is None:
        return GeocodeLookupResponse(source="not_found", **merged)

    location = get_geolocator().geocode(query, country_codes="br", addressdetails=False)
    if location is None:
        return GeocodeLookupResponse(source="not_found", **merged)

    return GeocodeLookupResponse(
        city=merged["city"],
        state=merged["state"],
        neighborhood=merged["neighborhood"],
        postal_code=merged["postal_code"],
        address=merged["address"],
        latitude=f"{location.latitude:.7f}",
        longitude=f"{location.longitude:.7f}",
        source="viacep+nominatim" if viacep_data else "nominatim",
    )


def fetch_viacep_address(postal_code: str) -> Optional[dict]:
    try:
        response = requests.get(
            f"https://viacep.com.br/ws/{postal_code}/json/",
            timeout=float(os.getenv("MARKET_GEOCODER_VIACEP_TIMEOUT", "10")),
        )
        response.raise_for_status()
        payload = response.json()
    except (requests.RequestException, ValueError):
        return None

    if not isinstance(payload, dict) or payload.get("erro") is True:
        return None

    return payload


def build_query(data: dict[str, Optional[str]]) -> Optional[str]:
    parts = [
        data.get("address"),
        data.get("neighborhood"),
        data.get("city"),
        data.get("state"),
        data.get("postal_code"),
        "Brasil",
    ]
    filtered = [part for part in parts if isinstance(part, str) and part.strip()]
    if len(filtered) < 3:
        return None

    return ", ".join(filtered)


def normalize_postal_code(value: Optional[str]) -> Optional[str]:
    if value is None:
        return None

    digits = re.sub(r"\D+", "", value)
    return digits or None


def first_non_empty(*values: Optional[str]) -> Optional[str]:
    for value in values:
        if isinstance(value, str) and value.strip():
            return value.strip()

    return None
