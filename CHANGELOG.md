# 22/01/2020

- Case insensitive search by name for dashboards.

# v1.0.0

## 14/1/2020

- Deprecation of `filter[<param>]=<value>` in favor of `<param>=<value>` on GET /topics endpoint.
- Add support for `includes=user` to GET /topics endpoint.
- Add pagination support for GET /dashboard endpoint.
- Add `application` field for dashboards and topics.
- Add `is_highlighted` and `is_featured` fields to dashboards.
- Improve the process of deleting dashboards (only ADMIN users of MANAGER users who own the dashboard can delete it).
- Add possibility of overwriting data when cloning a dashboard.
- Using the id of the user on the token when creating/cloning dashboards.
