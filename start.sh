#!/bin/bash
set -e
cd "$(dirname "$0")"
PORT=8877
cleanup() {
  trap - SIGINT EXIT
  local task_pids
  task_pids=$(jobs -pr)
  if [ -n "$task_pids" ]; then kill $task_pids 2>/dev/null || true; fi
  echo "服务已关闭"
}
trap cleanup SIGINT EXIT
if lsof -ti :$PORT >/dev/null 2>&1; then
  echo "端口 $PORT 已被占用，正在释放…"
  lsof -ti :$PORT | xargs kill -9 2>/dev/null || true
fi
echo "GentleDesk 手机 / 网页预览：http://localhost:$PORT"
echo "本地地址：http://localhost:$PORT"
(sleep 0.5 && open "http://localhost:$PORT") &
python3 -m http.server $PORT
