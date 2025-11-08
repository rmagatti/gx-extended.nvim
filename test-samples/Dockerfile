# Test file for gx-extended.nvim
# Test docker-hub extension by pressing gx on any FROM line

# Official images
FROM nginx:alpine
FROM node:18-slim
FROM postgres:15
FROM redis:7-alpine
FROM python:3.11
FROM ubuntu:22.04
FROM golang:1.21
FROM rust:1.72

# Official images with specific tags
FROM mysql:8.0.33
FROM mongo:6.0.8

# User/organization images
FROM hashicorp/terraform:latest
FROM grafana/grafana:10.0.0
FROM prom/prometheus:v2.45.0

# Multi-stage build example
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install

FROM nginx:alpine AS runner
COPY --from=builder /app/dist /usr/share/nginx/html

# Alpine variants
FROM alpine:3.18
FROM node:alpine3.18
