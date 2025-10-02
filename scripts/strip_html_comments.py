#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import re

def main() -> None:
    text = sys.stdin.read()
    # DOTALL: 개행 포함, non-greedy로 가장 가까운 --> 까지 제거
    cleaned = re.sub(r'<!--.*?-->', '', text, flags=re.DOTALL)
    # 필요시 연속 공백 줄을 정리하고 싶다면 아래 주석 해제
    # cleaned = re.sub(r'\n{3,}', '\n\n', cleaned)

    sys.stdout.write(cleaned)

if __name__ == "__main__":
    main()
