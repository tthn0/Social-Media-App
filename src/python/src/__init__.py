from flask import Flask, jsonify, request
from flask_restful import Api, Resource, reqparse
import requests
import pymongo
import dotenv
import time
import os

dotenv.load_dotenv()
app = Flask(__name__)
api = Api(app)

app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')

DATABASE = pymongo.MongoClient(
    os.getenv('CONNECTION_STR')
)['blog']

AUTHORIZATION = os.getenv('AUTHORIZATION')


class Posts(Resource):

    def get(self):
        # args = reqparse.RequestParser()
        # args.add_argument('starting_index', type=int, required=False)

        # if args.parse_args()['starting_index'] is None:
        #     index = 0
        # else:
        #     index = args.parse_args()['starting_index']

        # documents = [post for post in DATABASE['posts'].find({})]
        # documents = documents[index:index+5]

        args = reqparse.RequestParser()
        args.add_argument('author_id', type=str, required=False)

        if args.parse_args()['author_id']:
            documents = [
                post for post in DATABASE['posts'].find({
                    'author_id': int(args.parse_args()['author_id'])
                })
            ]
        else:
            documents = [post for post in DATABASE['posts'].find({})]

        for post in documents:
            author_id = post['author_id']
            del post['author_id']

            author = DATABASE['users'].find_one(
                {'_id': author_id}
            )

            post['author'] = author

        return jsonify(documents)

    def post(self):
        args = reqparse.RequestParser()
        args.add_argument('author_id', type=str, required=True)

        for arg in [
            'title',
            'body',
            'image',
        ]:
            args.add_argument(arg, type=str, required=True)

        if request.headers['Authorization'] == AUTHORIZATION:
            return_args = args.parse_args()
            return_args['date'] = int(time.time())
            return_args['author_id'] = int(return_args['author_id'])

            cursor = DATABASE['posts'].find(
                {}, {'_id': 1}
            ).sort(
                [('_id', -1)]
            ).limit(1)

            return_args['_id'] = cursor.next()['_id'] + 1

            if args.parse_args()['image']:
                r = requests.post(
                    'https://api.imgur.com/3/upload',
                    headers={
                        "Authorization": f"Client-ID {os.getenv('CLIENT_ID')}"
                    },
                    data={
                        'image': return_args['image'],
                        'type': 'base64',
                        'name': 'img.jpg',
                        'title': return_args['title'],
                    }
                )
                return_args['image'] = r.json()['data']['link']
            DATABASE['posts'].insert_one(return_args)
            return return_args

    def delete(self):
        args = reqparse.RequestParser()
        args.add_argument('post_id', type=str, required=True)

        if request.headers['Authorization'] == AUTHORIZATION:
            return_args = args.parse_args()

            DATABASE['posts'].delete_one({
                '_id': int(return_args['post_id']),
            })

            return return_args

    def patch(self):
        args = reqparse.RequestParser()

        for arg in [
            '_id',
            'title',
            'body',
        ]:
            args.add_argument(arg, type=str, required=True)

        if request.headers['Authorization'] == AUTHORIZATION:
            return_args = args.parse_args()

            fields_to_update = return_args.copy()
            del fields_to_update['_id']

            print(fields_to_update)

            DATABASE['posts'].update_one(
                {'_id': int(return_args['_id'])},
                {'$set': fields_to_update}
            )

            return return_args


class Users(Resource):

    def get(self):
        args = reqparse.RequestParser()
        args.add_argument('username', type=str, required=False)

        if args.parse_args()['username'] is None:
            return jsonify(
                [post for post in DATABASE['users'].find({})]
            )

        else:
            return jsonify(
                DATABASE['users'].find_one(
                    {'username': args.parse_args()['username']})
            )

    def post(self):
        args = reqparse.RequestParser()

        for arg in [
            'name',
            'username',
            'email',
            'password',
        ]:
            args.add_argument(arg, type=str, required=True)

        if request.headers['Authorization'] == AUTHORIZATION:
            return_args = args.parse_args()
            return_args['avatar'] = ''
            return_args['bio'] = ''

            cursor = DATABASE['users'].find(
                {}, {'_id': 1}
            ).sort(
                [('_id', -1)]
            ).limit(1)

            return_args['_id'] = cursor.next()['_id'] + 1

            DATABASE['users'].insert_one(return_args)

            return return_args

    def patch(self):
        args = reqparse.RequestParser()

        for arg in [
            '_id',
            'name',
            'username',
            'email',
            'password',
            'bio',
            'avatar',
        ]:
            args.add_argument(arg, type=str, required=True)

        if request.headers['Authorization'] == AUTHORIZATION:
            return_args = args.parse_args()
            return_args['_id'] = int(return_args['_id'])

            fields_to_update = return_args.copy()
            del fields_to_update['_id']

            old_user = DATABASE['users'].find_one(
                {'_id': return_args['_id']}
            )

            if return_args['avatar'] != old_user['avatar']:
                r = requests.post(
                    'https://api.imgur.com/3/upload',
                    headers={
                        "Authorization": f"Client-ID {os.getenv('CLIENT_ID')}"
                    },
                    data={
                        'image': return_args['avatar'],
                        'type': 'base64',
                        'name': 'img.jpg',
                        'title': 'test',
                    }
                )
                return_args['avatar'] = r.json()['data']['link']
                fields_to_update['avatar'] = r.json()['data']['link']

            DATABASE['users'].update_one(
                {'_id': return_args['_id']},
                {'$set': fields_to_update}
            )

            return return_args


api.add_resource(Posts, '/posts')
api.add_resource(Users, '/users')

if __name__ == "__main__":
    app.run(debug=True)
