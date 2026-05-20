---
name: html-page-workflow
description: 사용자가 단일 HTML 웹페이지, 랜딩페이지, 대시보드, 영화 추천 페이지, 포트폴리오, 서비스 메인 페이지 등을 짧게 요청할 때 사용하는 HTML 생성 workflow skill
---

# 역할
이 skill은 짧은 HTML 웹페이지 요청을 완성도 높은 `index.html` 생성 작업으로 확장한다.

# 사용 조건
사용자가 아래처럼 요청하면 이 skill을 사용한다.
- “영화 추천 html 웹페이지 만들어줘”
- “AI SaaS 랜딩페이지 만들어줘”
- “관리자 대시보드 html 만들어줘”
- “포트폴리오 웹페이지 만들어줘”
- “XXX 주제로 index.html 만들어줘”

# 실행 흐름
1. 사용자의 짧은 요청에서 웹페이지 주제를 추출한다.
2. 반드시 `html_builder` agent를 사용한다.
3. 출력 파일은 항상 `index.html` 하나로 한다.
4. HTML/CSS/JS는 한 파일 안에 작성한다.
5. 외부 CDN, npm, React, Vue는 사용하지 않는다.
6. 반응형 레이아웃을 포함한다.
7. 생성 후 `test_runner`를 직접 실행하지 않는다.
8. `git add`, `git commit`을 직접 실행하지 않는다.
9. 검증과 commit은 기존 Codex hook이 자동 처리하게 둔다.

# 기본 생성 품질
- 상단 네비게이션
- Hero 섹션
- 주요 카드/콘텐츠 섹션
- 추천/특징/CTA 중 주제에 맞는 섹션
- hover 또는 간단한 인터랙션
- Footer
- semantic HTML

# 완료 보고
작업 완료 후 짧게 보고한다.
- 생성 파일: `new_index.html`
- 포함 섹션
- 브라우저 실행 방법
- hook 검증/commit은 자동 처리된다고 안내

# 금지
- `test_runner` 직접 호출 금지
- `git add` / `git commit` 직접 실행 금지
- `git push` 절대 금지
- 프로젝트 외부 파일 수정 금지
- `~/.codex` 수정 금지
- `.claude` 수정 금지
