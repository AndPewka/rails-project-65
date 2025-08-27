<div align="center">

![Ruby](https://img.shields.io/badge/Ruby-3.2.2-red)
![Rails](https://img.shields.io/badge/Rails-7.2.2.2-brightgreen)
[![CI](https://github.com/AndPewka/rails-project-65/actions/workflows/ci.yml/badge.svg)](https://github.com/AndPewka/rails-project-65/actions)

# Доска объявлений (Hexlet Project 65)
</div>

> Учебное Rails-приложение: объявление/модерация/публикация.
> В проекте использованы: **OmniAuth GitHub**, **AASM** (FSM), **Ransack**, **Kaminari**, **Bootstrap 5**, **Pundit**, CI на **GitHub Actions**, деплой на **Render**.

---

## 🚀 Демо
<https://rails-project-64-pmc8.onrender.com/>  

---

## ✨ Функционал
- Вход через **GitHub** (OmniAuth, без Devise).
- Объявления (**Bulletin**) с атрибутами: `title`, `description`, `image`, `state`, `category_id`, `user_id`.
- Конечный автомат (**AASM**) для публикации:
  - `draft` → `under_moderation` → `published` / `rejected` → `archived`
- Профиль `/profile`: создание и управление объявлениями (отправка на модерацию, архивирование).
- Главная страница: выводятся **только опубликованные** объявления.
- Админ-панель: просмотр, публикация, отклонение, архивирование.
- Поиск/фильтрация (**Ransack**) + пагинация (**Kaminari**) на главной, в профиле и в админке.
- CI: тесты и линтеры в **GitHub Actions**.

---

## 🛠 Стек
| Слой | Выбор |
|---|---|
| Backend | Ruby **3.2.2**, Rails **7.2.2.2** |
| DB (prod) | PostgreSQL (Render free) |
| DB (dev/test) | SQLite3 |
| JS bundling | esbuild (`-j esbuild`) |
| CSS | Bootstrap 5 (`--css=bootstrap`) |
| Auth | OmniAuth GitHub |
| FSM | AASM |
| Search | Ransack |
| Pagination | Kaminari |
| AuthZ | Pundit |
| CI/CD | GitHub Actions → Render |

---

## ⚡ Быстрый старт локально
> Требования: Ruby 3.2.2, Node ≥ 18, Yarn или npm, SQLite3

```bash
# 1) Клонирование
git clone https://github.com/AndPewka/rails-project-65.git
cd rails-project-65

# 2) Зависимости
bundle install
yarn install --frozen-lockfile

# 3) Переменные окружения
cp .env.example .env
# Заполните .env:
# GITHUB_CLIENT_ID=...
# GITHUB_CLIENT_SECRET=...

# 4) Подготовка БД и ассетов
bundle exec rails db:setup
bundle exec rails assets:precompile

# 5) Запуск
bundle exec rails s
# → http://localhost:3000
