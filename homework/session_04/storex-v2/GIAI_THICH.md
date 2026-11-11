# Giải thích cấu hình healthcheck, depends_on và volumes

## 1. Vấn đề ban đầu
- `depends_on` dạng danh sách chỉ đợi container **được khởi động** (trạng thái running),
  không đợi dịch vụ bên trong **sẵn sàng nhận kết nối**. PostgreSQL cần vài giây để khởi tạo,
  nên Backend kết nối quá sớm và bị crash.
- PostgreSQL lưu dữ liệu trong `/var/lib/postgresql/data` **bên trong container**.
  `docker compose down` xóa container nên dữ liệu bị xóa theo.

## 2. Cơ chế healthcheck
Docker chạy định kỳ một lệnh kiểm tra bên trong container và dựa vào mã thoát (exit code)
để gán trạng thái: `starting` → `healthy` (lệnh trả về 0) hoặc `unhealthy` (thất bại liên tiếp quá `retries` lần).

| Service  | Lệnh kiểm tra                          | Ý nghĩa |
|----------|----------------------------------------|---------|
| postgres | `pg_isready -U admin -d storex_db`     | Công cụ có sẵn của PostgreSQL, trả về 0 khi server đã nhận kết nối vào database `storex_db`. |
| redis    | `redis-cli ping`                       | Redis trả lời `PONG` (exit code 0) khi sẵn sàng phục vụ. |

Tham số:
- `interval: 5s` – kiểm tra mỗi 5 giây.
- `timeout: 3s` – lệnh chạy quá 3 giây coi như thất bại.
- `retries: 10` – thất bại 10 lần liên tiếp thì đánh dấu `unhealthy`.
- `start_period: 10s` – thời gian khởi động ban đầu của PostgreSQL, thất bại trong khoảng này không bị tính.

## 3. depends_on với condition: service_healthy
Backend khai báo `condition: service_healthy` cho cả `postgres` và `redis`.
Docker Compose chỉ khởi động Backend khi **cả hai** đã ở trạng thái `healthy`,
nhờ đó Backend luôn kết nối được ngay lần đầu.

Thứ tự khởi động: `postgres` + `redis` (song song) → đợi healthy → `backend`.

## 4. Volumes
Khai báo named volume `postgres_data` và mount vào `/var/lib/postgresql/data`.
Volume do Docker quản lý, nằm **ngoài vòng đời container**:
- `docker compose down` xóa container nhưng **giữ volume** → `up` lại vẫn còn dữ liệu.
- Chỉ `docker compose down -v` mới xóa volume (mất dữ liệu).
