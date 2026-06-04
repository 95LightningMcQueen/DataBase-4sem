from pymongo import MongoClient


client = MongoClient('mongodb://localhost:27017/')
db = client['Catalog']
collection = db['PC_components']
collection.delete_many({})

data = [
    {'Production': 'ASUS', 'Model': 'Prime B550', 'Price': 150, 'Category': {'Type': 'материнская плата', 'Description': 'ATX', 'Format': 'ATX', 'Socket': 'AM4'}},
    {'Production': 'MSI', 'Model': 'B450M', 'Price': 100, 'Category': {'Type': 'материнская плата', 'Description': 'Micro-ATX', 'Format': 'mATX', 'Socket': 'AM4'}},
    {'Production': 'Gigabyte', 'Model': 'Z690', 'Price': 200, 'Category': {'Type': 'материнская плата', 'Description': 'Gaming', 'Format': 'ATX', 'Socket': 'LGA1700'}},
    {'Production': 'ASRock', 'Model': 'H510', 'Price': 80, 'Category': {'Type': 'материнская плата', 'Description': 'Office', 'Format': 'mATX', 'Socket': 'LGA1200'}},
    {'Production': 'ASUS', 'Model': 'ROG Strix', 'Price': 300, 'Category': {'Type': 'материнская плата', 'Description': 'High-end', 'Format': 'ATX', 'Socket': 'AM5'}},
    {'Production': 'MSI', 'Model': 'A520', 'Price': 90, 'Category': {'Type': 'материнская плата', 'Description': 'Budget', 'Format': 'mATX', 'Socket': 'AM4'}},

    {'Production': 'AMD', 'Model': 'Ryzen 5 5600', 'Price': 180, 'Category': {'Type': 'процессор', 'Description': '6 ядер', 'Socket': 'AM4', 'Frequency': '3.5GHz'}},
    {'Production': 'Intel', 'Model': 'Core i5-12400', 'Price': 200, 'Category': {'Type': 'процессор', 'Description': '6 ядер', 'Socket': 'LGA1700', 'Frequency': '2.5GHz'}},
    {'Production': 'AMD', 'Model': 'Ryzen 7 5800X', 'Price': 250, 'Category': {'Type': 'процессор', 'Description': '8 ядер', 'Socket': 'AM4', 'Frequency': '3.8GHz'}},
    {'Production': 'Intel', 'Model': 'Core i3-12100', 'Price': 120, 'Category': {'Type': 'процессор', 'Description': '4 ядра', 'Socket': 'LGA1700', 'Frequency': '3.3GHz'}},
    {'Production': 'AMD', 'Model': 'Ryzen 9 5900X', 'Price': 350, 'Category': {'Type': 'процессор', 'Description': '12 ядер', 'Socket': 'AM4', 'Frequency': '3.7GHz'}},
    {'Production': 'Intel', 'Model': 'Core i7-12700', 'Price': 300, 'Category': {'Type': 'процессор', 'Description': '12 ядер', 'Socket': 'LGA1700', 'Frequency': '2.1GHz'}},

    {'Production': 'Kingston', 'Model': 'Fury 8GB', 'Price': 40, 'Category': {'Type': 'ОЗУ', 'Description': 'DDR4', 'Frequency': '3200MHz', 'Capacity': '8GB'}},
    {'Production': 'Corsair', 'Model': 'Vengeance 16GB', 'Price': 70, 'Category': {'Type': 'ОЗУ', 'Description': 'DDR4', 'Frequency': '3600MHz', 'Capacity': '16GB'}},
    {'Production': 'Crucial', 'Model': 'Basic 8GB', 'Price': 35, 'Category': {'Type': 'ОЗУ', 'Description': 'DDR4', 'Frequency': '2666MHz', 'Capacity': '8GB'}},
    {'Production': 'G.Skill', 'Model': 'Trident 32GB', 'Price': 150, 'Category': {'Type': 'ОЗУ', 'Description': 'DDR5', 'Frequency': '5600MHz', 'Capacity': '32GB'}},
    {'Production': 'Patriot', 'Model': 'Viper 16GB', 'Price': 65, 'Category': {'Type': 'ОЗУ', 'Description': 'DDR4', 'Frequency': '3200MHz', 'Capacity': '16GB'}},
    {'Production': 'TeamGroup', 'Model': 'Elite 8GB', 'Price': 38, 'Category': {'Type': 'ОЗУ', 'Description': 'DDR4', 'Frequency': '3000MHz', 'Capacity': '8GB'}},

    {'Production': 'Samsung', 'Model': '980 Pro', 'Price': 120, 'Category': {'Type': 'ПЗУ', 'Description': 'SSD NVMe', 'FormFactor': 'M.2', 'Capacity': '1TB'}},
    {'Production': 'WD', 'Model': 'Blue 500GB', 'Price': 50, 'Category': {'Type': 'ПЗУ', 'Description': 'SSD SATA', 'FormFactor': '2.5\'', 'Capacity': '500GB'}},
    {'Production': 'Seagate', 'Model': 'Barracuda 2TB', 'Price': 60, 'Category': {'Type': 'ПЗУ', 'Description': 'HDD', 'FormFactor': '3.5\'', 'Capacity': '2TB'}},
    {'Production': 'Crucial', 'Model': 'P2 500GB', 'Price': 45, 'Category': {'Type': 'ПЗУ', 'Description': 'SSD NVMe', 'FormFactor': 'M.2', 'Capacity': '500GB'}},
    {'Production': 'Kingston', 'Model': 'A400 240GB', 'Price': 30, 'Category': {'Type': 'ПЗУ', 'Description': 'SSD SATA', 'FormFactor': '2.5\'', 'Capacity': '240GB'}},
    {'Production': 'Toshiba', 'Model': 'P300 1TB', 'Price': 40, 'Category': {'Type': 'ПЗУ', 'Description': 'HDD', 'FormFactor': '3.5\'', 'Capacity': '1TB'}},

    {'Production': 'NVIDIA', 'Model': 'RTX 3060', 'Price': 350, 'Category': {'Type': 'видеокарта', 'Description': 'Gaming', 'Capacity': '12GB', 'Ports': 'HDMI, 3xDP'}},
    {'Production': 'AMD', 'Model': 'RX 6600', 'Price': 250, 'Category': {'Type': 'видеокарта', 'Description': 'Gaming', 'Capacity': '8GB', 'Ports': 'HDMI, 3xDP'}},
    {'Production': 'NVIDIA', 'Model': 'GTX 1650', 'Price': 150, 'Category': {'Type': 'видеокарта', 'Description': 'Budget', 'Capacity': '4GB', 'Ports': 'HDMI, DVI, DP'}},
    {'Production': 'NVIDIA', 'Model': 'RTX 4070', 'Price': 600, 'Category': {'Type': 'видеокарта', 'Description': 'High-end', 'Capacity': '12GB', 'Ports': 'HDMI, 3xDP'}},
    {'Production': 'AMD', 'Model': 'RX 6700 XT', 'Price': 400, 'Category': {'Type': 'видеокарта', 'Description': 'Gaming', 'Capacity': '12GB', 'Ports': 'HDMI, 3xDP'}},
    {'Production': 'NVIDIA', 'Model': 'RTX 3050', 'Price': 220, 'Category': {'Type': 'видеокарта', 'Description': 'Entry', 'Capacity': '8GB', 'Ports': 'HDMI, DP'}}
]
collection.insert_many(data)


print('Самая дешёвая сборка:')
min_price = collection.find().sort('Price', 1).limit(1)
for elem in min_price:
    print(f"{elem['Production']} {elem['Model']} - {elem['Price']}$")
print('\nСамая дорогая сборка:')
max_price = collection.find().sort('Price', -1).limit(1)
for elem in max_price:
    print(f"{elem['Production']} {elem['Model']} - {elem['Price']}$")

print('\n3 и 5 по стоимости товары из каждой категории:')
categories = collection.distinct('Category.Type')
for elem in categories:
    print(f'\nКатегория: {elem}')
    items = list(collection.find({'Category.Type': elem}).sort('Price', 1))
    if len(items) >= 5:
        print(f"3-й: {items[2]['Production']} {items[2]['Model']} ({items[2]['Price']}$)")
        print(f"5-й: {items[4]['Production']} {items[4]['Model']} ({items[4]['Price']}$)")
    elif len(items) >= 3:
        print(f"3-й: {items[2]['Production']} {items[2]['Model']} ({items[2]['Price']}$)")
        print('В категории меньше 5 товаров, 5-й не найден')
    else:
        print(f'В категории меньше 3 товапов')

print('\nВсе возможные сборки на сокете AM4:')
am4_bilds = collection.find({'Category.Socket': 'AM4'})
for elem in am4_bilds:
    print(f"{elem['Production']} {elem['Model']} (Тип: {elem['Category']['Type']})")
