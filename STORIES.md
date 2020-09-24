# Aracelli's Jewelry

## Users

A *user* has a *username*, an *email_address*, a *password_digest*, and an *is_admin* status.

A *user* can comment, view comments and posts, edit their comment, or delete their comment.

An admin *user* in addition can create posts, edit their own posts, and delete other user's posts and comments

## Posts

A post has a *title*, a *body* and has_many *images* and *comments*

## Comments

A comment has a *body* and belongs_to a *user* and a *post*

## Images

belongs_to a *post*