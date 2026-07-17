# Program, Process, Thread

## 1. Khái niệm

**Program (chương trình)**
- Là một tập hợp các chỉ thị (instructions) được viết bằng ngôn ngữ lập trình, biên dịch thành file thực thi (executable) nằm trên đĩa (ổ cứng).
- Là thực thể **thụ động (passive)** — chỉ là dữ liệu tĩnh, chưa được nạp vào bộ nhớ, chưa chạy.
- Ví dụ: file `a.out`, `program.exe`, `/bin/ls`.

**Process (tiến trình)**
- Là một **instance đang thực thi** của một program — khi program được nạp vào RAM và CPU bắt đầu thực thi nó.
- Là thực thể **chủ động (active)**, có vòng đời riêng (tạo, chạy, chờ, kết thúc).
- Có không gian địa chỉ (address space) riêng biệt: code segment, data segment, heap, stack.
- Có các tài nguyên hệ thống riêng: bộ nhớ, file descriptor, PID, bảng biến môi trường...
- Một program có thể được chạy nhiều lần → tạo ra nhiều process độc lập (ví dụ mở nhiều cửa sổ Chrome, mỗi cửa sổ có thể là 1 process khác nhau nhưng cùng chạy từ file thực thi `chrome.exe`).

**Thread (luồng)**
- Là đơn vị thực thi **nhỏ nhất** mà hệ điều hành có thể lập lịch (schedule) trên CPU.
- Là một "luồng điều khiển" (flow of execution) nằm **bên trong một process**.
- Một process có thể có **một hoặc nhiều thread** (multi-threading).
- Các thread trong cùng một process **chia sẻ** không gian địa chỉ, heap, file descriptor, biến toàn cục... nhưng mỗi thread có **stack riêng, program counter riêng, tập thanh ghi riêng**.

Mối quan hệ phân cấp:
```
Program (file trên đĩa)
   └── Process (instance đang chạy, có PID)
          └── Thread 1, Thread 2, ... (có TID, chia sẻ tài nguyên process)
```

## 2. Bảng so sánh

| Tiêu chí | Program | Process | Thread |
|---|---|---|---|
| Bản chất | Thực thể thụ động, chỉ là file trên đĩa | Thực thể chủ động, program đang được thực thi | Đơn vị thực thi nhỏ nhất trong 1 process |
| Trạng thái | Tĩnh (static) | Động (dynamic), có vòng đời | Động, vòng đời gắn liền với process cha |
| Bộ nhớ/Không gian địa chỉ | Không có (chưa nạp vào RAM) | Có không gian địa chỉ riêng, độc lập với process khác | Dùng chung không gian địa chỉ với các thread khác trong cùng process |
| Định danh | Tên file | PID (Process ID) | TID (Thread ID) |
| Tài nguyên | Không sở hữu tài nguyên hệ thống | Sở hữu tài nguyên riêng: bộ nhớ, file, handle... | Chia sẻ tài nguyên của process cha (trừ stack, register, PC) |
| Giao tiếp | Không áp dụng | Cần IPC (Inter-Process Communication): pipe, socket, shared memory... vì không gian địa chỉ tách biệt | Giao tiếp trực tiếp qua biến chia sẻ (vì cùng không gian địa chỉ) → nhanh hơn nhưng dễ race condition |
| Chi phí tạo mới | Không áp dụng | Chi phí cao (phải cấp phát address space, bảng trang mới) | Chi phí thấp hơn nhiều (dùng lại tài nguyên process) |
| Chi phí chuyển ngữ cảnh (context switch) | Không áp dụng | Cao (phải đổi bảng trang, cache thường bị flush) | Thấp hơn (không cần đổi address space) |
| Ảnh hưởng khi lỗi | Không áp dụng | Một process lỗi thường không ảnh hưởng process khác (cô lập) | Một thread lỗi (vd: truy cập sai bộ nhớ) có thể làm sập toàn bộ process (vì chia sẻ bộ nhớ) |
| Ví dụ | File `firefox.exe` trên ổ đĩa | Firefox đang chạy trong Task Manager (mỗi tab/process con có PID riêng) | Trong 1 process Firefox: thread render giao diện, thread tải mạng, thread xử lý JS |

**Giống nhau:**
- Cả process và thread đều là các **đơn vị thực thi** được HĐH lập lịch (schedule) chạy trên CPU.
- Cả hai đều có trạng thái (running, ready, waiting/blocked).
- Cả hai đều cần CPU time để hoạt động, đều được quản lý bởi kernel (thông qua scheduler).
- Program là "nguồn gốc" chung, cả process lẫn thread đều xuất phát từ việc thực thi program.

## 3. PID và TID

**PID (Process Identifier)**
- Là số định danh duy nhất mà HĐH gán cho **mỗi process** khi nó được tạo ra.
- Dùng để quản lý, theo dõi, gửi tín hiệu (signal) đến process (vd lệnh `kill -9 <PID>`).
- Mỗi process có **đúng 1 PID**, không trùng với PID nào khác đang tồn tại tại cùng thời điểm.

**TID (Thread Identifier)**
- Là số định danh duy nhất cho **mỗi thread**.
- Trên Linux, mỗi thread thực chất cũng được kernel biểu diễn như một "task" có ID riêng (kernel gọi là `tid`), nhưng các thread trong cùng process chia sẻ **cùng một PID** (được gọi là Thread Group ID – `TGID`).

**Phân biệt cụ thể (trên Linux):**

| | PID | TID |
|---|---|---|
| Đại diện cho | Cả process (nhóm thread) | Một thread cụ thể |
| Số lượng trên 1 process | 1 PID duy nhất | Nhiều TID nếu process có nhiều thread |
| Quan hệ | PID = TID của **thread chính (main thread)** — thread đầu tiên khi process khởi tạo | Mỗi thread con sinh ra sau đó có TID riêng, khác PID |
| Lệnh xem | `ps -ef`, `top` (mặc định chỉ hiện PID) | `ps -eLf`, `top -H`, hoặc xem thư mục `/proc/<pid>/task/` |
| Ý nghĩa hệ thống | Định danh dùng cho `kill`, quản lý ở mức process | Định danh dùng khi cần debug/theo dõi từng thread riêng lẻ (vd profiling, gán CPU affinity cho thread) |

**Ví dụ minh họa:** Process Firefox có PID = 5000. Nó tạo ra 3 thread → thread chính có TID = 5000 (trùng PID), 2 thread còn lại có TID = 5001, 5002. Khi gõ `kill 5000` → toàn bộ process (và mọi thread bên trong) bị dừng, vì kill tác động ở mức process chứ không nhắm riêng 1 thread.

