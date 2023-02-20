import requests
from conditions import *
from bs4 import BeautifulSoup

def scrapeRent(numberOfSearch: int = 30, # 10, 20, 30, 50, 100
               city: str = "新宿区",
               walkDistance: str = "指定しない",
               rentUpper: int = 9999999,
               layout: list = ["2LDK"]):
    data = []

    suumoURL = f"https://suumo.jp/jj/chintai/ichiran/FR301FC005/?pc={numberOfSearch}&ar=030&bs=040&ta=13&sc={cityList[city]}&et={walkDistanceList[walkDistance]}&cb={0.0}&ct={rentUpper / 10000 if rentUpper != 9999999 else 9999999}"
    for i in layout:
        suumoURL += f"&md={layoutList[i]}"

    r = requests.get(suumoURL)
    soup = BeautifulSoup(r.content, "html.parser")

    # Suumoからスクレイプ
    try: 
        titles = [i.text for i in soup.find_all(class_ = "js-cassetLinkHref")]
        addresses = [i.text.strip() for i in soup.find_all(class_ = "detailbox-property-col")][4::5]
        rents = [int(float(i.text[0:-2]) * 10000) for i in soup.find_all(class_ = "detailbox-property-point")]
        layouts = [i.text.split("\n")[2] for i in soup.find_all(class_ = "detailbox-property-col detailbox-property--col3")][0::2]
        ages = [i.text.split("\n")[-2] for i in soup.find_all(class_ = "detailbox-property-col detailbox-property--col3")][1::2]
        stations = [i.text.split("\n")[1] for i in soup.find_all(class_ = "detailnote-box")][0::2]
        details = []
        rentIdentification = []

        for i in soup.find_all(class_ = "js-cassetLinkHref"):
            rentIdentification.append(i.get("href")[12:-1])
            details.append("https://suumo.jp" + i.get("href"))

        numberOfGets = len(rentIdentification)
       
        buildingImage = []
        layoutImage = []
        fetchedImage = []
        blankImage = "https://maintenance.suumo.jp/maintenance.jpg"
        for index, item in enumerate(soup.find_all(class_ = "js-noContextMenu")):

            if item.get("rel") and "_gw" in item.get("rel"):
                fetchedImage.append(item.get("rel"))
                buildingImage.append(item.get("rel").replace("_gw", "_go"))
            elif item.get("rel") and "_cw" in item.get("rel"):
                fetchedImage.append(item.get("rel"))
                layoutImage.append(item.get("rel").replace("_cw", "_co"))
            elif item.get("rel") is None:
                buildingImage.append(blankImage)
                layoutImage.append(blankImage)
                fetchedImage.extend([blankImage, blankImage])

        if numberOfGets == 0:
            print("条件に合う物件が見つかりません。")

    except Exception as e:
        print("物件を取得できません。")
        print(e)

    coordinates = []
    for i in addresses:
        addressURL = f"https://msearch.gsi.go.jp/address-search/AddressSearch?q={i}"
        coordinates.append(requests.get(addressURL).json()[0]["geometry"]["coordinates"])

    # デバッグ用プリント 
    for i in range(numberOfGets):
        print(f"{i}:\n識別番号: {rentIdentification[i]}\n物件名: {titles[i]}\n住所: {addresses[i]}\n家賃: {rents[i]}\n間取り: {layouts[i]}\n築年数: {ages[i]}\n最寄駅: {stations[i]}\n外観: {buildingImage[i]}\n間取り図: {layoutImage[i]}\n緯度経度: {coordinates[i]}\n詳細: {details[i]}\n\n")

    # API用辞書型データをまとめる
    for i in range(numberOfGets):
        infoDict = {
            "id": i + 1,
            "title": titles[i],
            "address": addresses[i],
            "rent": rents[i],
            "age": ages[i],
            "layout": layouts[i],
            "station": stations[i],
            "buildingImage": buildingImage[i],
            "layoutImage": layoutImage[i],
            "coordinate": coordinates[i],
            "detail": details[i]
        }
        data.append(infoDict)

    return data

if __name__ == "__main__":

    # テスト用条件
    data = scrapeRent(
        city = "新宿区",
        walkDistance = "10分以内",
        numberOfSearch = 10,
        rentUpper = 400000,
        layout = ["3DK"]
    )