# Changelog

## owidapi (development version)

- Fixed
  [`owid_get_catalog()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_get_catalog.md)
  returning only the first 1000 charts. Datasette caps the `_size=max`
  parameter at its `max_returned_rows` setting, so the catalog was
  silently truncated and
  [`owid_search()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_search.md)
  searched only a fraction of it. The catalog is now paged through and
  returned in full. Rows come back sorted by `id` as a result.
- Fixed
  [`owid_get_catalog()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_get_catalog.md)
  failing after OWID removed the `isIndexable` column from the catalog.
  Logical and date columns are now only parsed when they are actually
  present, so future schema changes no longer break the function.
- Guarded the
  [`owid_search()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_search.md)
  example against an unreachable API, since
  [`owid_get_catalog()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_get_catalog.md)
  returns `NULL` in that case.
- Tests now use mocked `httr2` responses instead of live API calls. The
  few remaining tests against the real API check that the OWID schema
  still matches what the package expects and are skipped on CRAN.

## owidapi 0.1.1

CRAN release: 2025-06-23

- Encapsulated request logic in internal `perform_request()` function.
- Updated variable parsing & introduced graceful error handling in
  [`owid_get_catalog()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_get_catalog.md)

## owidapi 0.1.0

CRAN release: 2025-02-27

- Initial release with
  [`owid_get()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_get.md),
  [`owid_get_metadata()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_get_metadata.md),
  [`owid_get_catalog()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_get_catalog.md),
  and
  [`owid_search()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_search.md).
- Includes experimental helpers for shiny apps
  [`owid_output()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_output.md)
  and
  [`owid_server()`](https://tidy-intelligence.github.io/r-owidapi/reference/owid_output.md).
