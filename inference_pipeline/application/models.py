import datetime

from typing import Optional
from pydantic import BaseModel


class IncomingData(BaseModel):
    model_name: str
    input_data: str


class InferenceResult(BaseModel):

    __tablename__ = "inference_result"

    model_name: str
    input_data: str
    prediction: str
    annotated: Optional[bool] = False
    annotation_value: Optional[str]
    timestamp: Optional[datetime.datetime] = datetime.datetime.utcnow()

