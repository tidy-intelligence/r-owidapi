# owidapi (development version)

- Fixed `owid_get_catalog()` failing after OWID removed the `isIndexable` column
  from the catalog. Logical and date columns are now only parsed when they are
  actually present, so future schema changes no longer break the function.
- Guarded the `owid_search()` example against an unreachable API, since
  `owid_get_catalog()` returns `NULL` in that case.
- Tests now use mocked `httr2` responses instead of live API calls. The few
  remaining tests against the real API check that the OWID schema still matches
  what the package expects and are skipped on CRAN.

# owidapi 0.1.1

- Encapsulated request logic in internal `perform_request()` function.
- Updated variable parsing & introduced graceful error handling in `owid_get_catalog()`

# owidapi 0.1.0

- Initial release with `owid_get()`, `owid_get_metadata()`, `owid_get_catalog()`, and `owid_search()`.
- Includes experimental helpers for shiny apps `owid_output()` and `owid_server()`.
