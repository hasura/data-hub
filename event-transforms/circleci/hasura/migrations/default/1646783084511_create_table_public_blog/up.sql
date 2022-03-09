CREATE TABLE "public"."blog" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "title" text NOT NULL, "content" text NOT NULL, PRIMARY KEY ("id") );
CREATE EXTENSION IF NOT EXISTS pgcrypto;
