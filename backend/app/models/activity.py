from datetime import datetime
from typing import Optional
from sqlmodel import SQLModel, Field
from pydantic import validator

class Activity(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    category: str # transport/energy/food/waste
    subtype: str
    quantity: float
    unit: str
    activity_date: datetime
    co2e_kg: float
    notes: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)

    @validator("quantity")
    def quantity_must_be_positive(cls, v):
        if v <= 0:
            raise ValueError("Quantity must be greater than zero.")
        return v
