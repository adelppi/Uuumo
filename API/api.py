from scrape import scrapeRent
from flask import *

app = Flask(__name__)

@app.route("/", methods = ["GET"])
def root():
    return {"message": "OK"}

@app.route("/rents/", methods = ["GET"])
def returnInfo():

    # クエリパラメータを取得・整形
    city = str(request.args.get("city"))
    rent = int(request.args.get("rent"))
    walkDistance = request.args.get("walkDistance")
    layout = request.args.get("layout").replace("\"", "").replace("[", "").replace("]", "").split(", ")

    data = scrapeRent(
        numberOfSearch = 10,
        city = city,
        walkDistance = walkDistance,
        rentUpper = rent,
        layout = layout
    )
    
    return data

if __name__ == "__main__":
    app.run(port = 2500)