import random


servers = {i: [] for i in range(1, 13)}
results = ['SUCCESS', 'FAILURE', 'PENDING', 'CANCELLED']
for log_id in range(1, 1000001):
    server_id = (log_id % 12) + 1
    day = (log_id % 365) + 1
    action_date = f'2025-01-{day:03d}'
    seconds = (log_id * 123) % 86400
    h, m, s = seconds // 3600, (seconds % 3600) // 60, seconds % 60
    action_time = f'{h:02d}:{m:02d}:{s:02d}'
    log_entry = {
        'id': f'LOG_{log_id:07d}',
        'username': f'USER_{log_id % 500000 + 1:06d}',
        'action_date': action_date,
        'action_time': action_time,
        'action_result': random.choice(results)
    }
    servers[server_id].append(log_entry)

for i in range(1, 13):
    print(f'Сервер {i}: хранит {len(servers[i])} записей из таблицы USER_LOGS')
