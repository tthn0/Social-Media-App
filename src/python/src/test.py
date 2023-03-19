import requests

# r = requests.post(
#     'http://127.0.0.1:5000/posts',
#     data={
#         'author_id': 0,
#         'title': 'Post Title',
#         'body': 'Post Body',
#         'image': '',
#     },
#     headers={
#         'Authorization': '12345',
#     }
# )

# r = requests.post(
#     'http://127.0.0.1:5000/users',
#     data={
#         'name': 'Full Name',
#         'username': 'new_username',
#         'email': 'email@test.test',
#         'password': 'pw',
#     },
#     headers={
#         'Authorization': '12345',
#     }
# )

# r = requests.delete(
#     'http://127.0.0.1:5000/posts',
#     data={
#         'post_id': '4'
#     },
#     headers={
#         'Authorization': '12345',
#     }
# )

# r = requests.patch(
#     'http://127.0.0.1:5000/users',
#     data={
#         'id': '0',
#         'username': 'test',
#         'name': 'New Name',
#         'email': 'new@email.com',
#         'password': 'newpass',
#         'bio': 'new bio',
#         'avatar': 'https://i.imgur.com/3EsKsxm.png',
#     },
#     headers={
#         'Authorization': '12345',
#     }
# )

r = requests.patch(
    'http://127.0.0.1:5000/posts',
    data={
        "_id": '5',
        "title": "Testinggggg",
        "body": "Bruh",
    },
    headers={
        'Authorization': '12345',
    }
)

print(r.json())
