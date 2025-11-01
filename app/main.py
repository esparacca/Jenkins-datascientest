from typing import Union
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "We Like Datascientest, and we did it. We built a Complete CI/CD Pipeline, how ecxiting, with a few mods from myself to force pushing latest version! DAIEEEEEEE!!!!!"}
