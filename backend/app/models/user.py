from datetime import datetime
from typing import Optional
from sqlmodel import SQLModel, Field
import re
from pydantic import validator

class UserBase(SQLModel):
    email: str = Field(unique=True, index=True)
    full_name: Optional[str] = None
    country: str = Field(default="IN")
    region: Optional[str] = None
    household_size: int = Field(default=1)
    diet_baseline: str = Field(default="omnivore") # vegan/vegetarian/omnivore/high_meat

    @validator("email")
    def validate_email(cls, v):
        if not re.match(r"[^@]+@[^@]+\.[^@]+", v):
            raise ValueError("Invalid email format.")
        return v

    @validator("household_size")
    def validate_household_size(cls, v):
        if v < 1:
            raise ValueError("Household size must be at least 1.")
        return v

class User(UserBase, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    hashed_password: str
    created_at: datetime = Field(default_factory=datetime.utcnow)
