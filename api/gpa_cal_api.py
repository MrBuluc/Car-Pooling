# uvicorn gpa_cal_api:app --reload
from typing import List
from fastapi import FastAPI, Body
import json

app = FastAPI()


@app.get("/")
def root():
    return "Bu API GPA Hesaplama içindir"


@app.post("/calGPA/puan")
def calGPAPuan(body: str = Body()):
    return {"GPA": calculateGPA(calculateKatSayiFromPuan(json.loads(body)))}


@app.post("/calGPA/harfNotu")
def calGPAHarfNotu(body: str = Body()):
    return {"GPA": calculateGPA(calculateKatsayiFromHarfNotu(json.loads(body)))}


@app.post("/calGPA/katsayi")
def calGPAKatsayi(body: str = Body()):
    return {"GPA": calculateGPA(json.loads(body))}


def calculateKatSayiFromPuan(dersList):
    #ders = {"kredi": 3, "puan": 82}
    for ders in dersList:
        puan = ders["puan"]
        katSayi = 4
        if (puan >= 95):
            katSayi = 4
        elif (puan >= 90 and puan <= 94):
            katSayi = 3.75
        elif (puan >= 85 and puan <= 89):
            katSayi = 3.5
        elif (puan >= 80 and puan <= 84):
            katSayi = 3.25
        elif (puan >= 75 and puan <= 79):
            katSayi = 3
        elif (puan >= 70 and puan <= 74):
            katSayi = 2.75
        elif (puan >= 65 and puan <= 69):
            katSayi = 2.5
        elif (puan >= 60 and puan <= 64):
            katSayi = 2.25
        elif (puan >= 55 and puan <= 59):
            katSayi = 2
        elif (puan >= 50 and puan <= 54):
            katSayi = 1.75
        else:
            katSayi = 0
        ders["katsayi"] = katSayi
    return dersList


def calculateKatsayiFromHarfNotu(dersList):
    katsayi = 4
    for ders in dersList:
        harfNotu = ders["harfNotu"]
        match harfNotu:
            case "A1":
                katsayi = 4
            case "A2":
                katsayi = 3.75
            case "A3":
                katsayi = 3.5
            case "B1":
                katsayi = 3.25
            case "B2":
                katsayi = 3
            case "B3":
                katsayi = 2.75
            case "C1":
                katsayi = 2.5
            case "C2":
                katsayi = 2.25
            case "C3":
                katsayi = 2
            case "D":
                katsayi = 1.75
            case _:
                katsayi = 0

        ders["katsayi"] = katsayi
    return dersList


def calculateGPA(dersList):
    toplamNot = 0
    toplamKredi = 0

    for ders in dersList:
        toplamNot += ders["kredi"] * float(ders["katsayi"])
        toplamKredi += ders["kredi"]

    return round((toplamNot / toplamKredi), 2)
