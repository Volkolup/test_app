from fastapi import FastAPI

app = FastAPI(title="Clinic App", version="0.1.0")


@app.get("/")
def read_root() -> dict[str, str]:
    return {"message": "Hello, World!"}


@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}
