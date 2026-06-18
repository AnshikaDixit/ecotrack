from functools import lru_cache
from sqlmodel import Session, select
from app.models.emission_factor import EmissionFactor
from app.db.database import engine

@lru_cache(maxsize=128)
def _get_cached_emission_factor(category: str, subtype: str, region: str = None) -> EmissionFactor:
    with Session(engine) as session:
        query = select(EmissionFactor).where(
            EmissionFactor.category == category,
            EmissionFactor.subtype == subtype
        )
        results = session.exec(query).all()
        
        if not results:
            raise ValueError(f"Emission factor not found for {category} / {subtype}")
            
        if region:
            for r in results:
                if r.region == region:
                    return r
        
        for r in results:
            if r.region is None:
                return r
                
        return results[0]

def lookup_emission_factor(session: Session, category: str, subtype: str, region: str = None) -> EmissionFactor:
    """
    Look up an emission factor from the database.
    Uses lru_cache under the hood to prevent redundant DB calls for identical factors.
    """
    return _get_cached_emission_factor(category, subtype, region)

def calculate_co2e(session: Session, category: str, subtype: str, quantity: float, unit: str, region: str = None) -> float:
    factor = lookup_emission_factor(session, category, subtype, region)
    
    # Normally we'd check if units match, but for MVP we assume UI enforces correct units.
    return round(quantity * factor.factor_value, 3)
