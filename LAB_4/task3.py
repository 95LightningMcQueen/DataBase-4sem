from pymongo import MongoClient
import gridfs


client = MongoClient('mongodb://localhost:27017/')
db = client['AVATARS']
fs = gridfs.GridFS(db)

def save_avatar(user_id, image_path):
    exist_avatar = fs.find_one({'user_id': user_id})
    if exist_avatar:
        fs.delete(exist_avatar._id)
    with open(image_path, 'rb') as image_file:
        file_id = fs.put(image_file, filename=f'avatar_{user_id}.jpg', user_id=user_id)
        print(f'Аватар пользователя {user_id} сохранен с ID: {file_id}')

def get_avatar(user_id, output_path):
    file_data = fs.find_one({'user_id': user_id})
    if not file_data:
        print('Аватар не найден')
    else:
        with open(output_path, 'wb') as output_file:
            output_file.write(file_data.read())
        print(f'Аватар для пользователя {user_id} успешно извлечен в {output_path}')


save_avatar('user1', 'kchau.jpg')
get_avatar('user1', 'kchau.jpg')
