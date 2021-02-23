## 23/02/2021

- Fix issue with CT legacy support on user data injection

## 12/02/2021

- Remove dependency on CT's `authenticated` functionality

## 18/01/2021

- Remove dependency on user data injected by Control Tower.
- Set cache headers to private by default.

# 1.3.2

## 17/11/2020

- Set dashboard's `is_featured` and `is_highlighted` to `false` on dashboard and topic clone 

# v1.3.1

## 09/04/2020

- Update k8s configuration with node affinity.

# v1.3.0

## 19/03/2020

- Add new fields to the dashboard model for `author_title` and `author_image`
- Security update on the `json` gem

# v1.2.0

## 28/02/2020

- Fix problem cloning dashboards without content.
- Add possibility of sorting dashboards by user fields (such as name or role).
- Add `is-featured` field to dashboards

# v1.1.0

## 27/1/2020

- Using the dashboard's user id on create/clone dashboards.
- Allow case insensitive search for dashboards.

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
