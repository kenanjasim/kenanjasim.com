# Redirects: kenanjasim.com → kenan.sh

The blog moved from kenanjasim.com to kenan.sh with **identical paths**, so almost everything is
covered by one dynamic Single Redirect rule. A small Bulk Redirect list handles the rest.

- `redirect-map.csv` lists every old URL, its new URL, and which mechanism handles it (40 via the
  rule, 6 via bulk).
- `bulk-redirects.csv` is ready to import into a Cloudflare Bulk Redirect list.
- `verify-redirects.sh` curls every old URL and checks it returns a 301 to the right place.

## 1. Single Redirect rule (zone: kenanjasim.com)

Go to **Rules → Redirect Rules → Create rule** and choose *Custom filter expression*. Then use
**Edit expression** and paste:

```
(http.host in {"kenanjasim.com" "www.kenanjasim.com"}) and (
  starts_with(http.request.uri.path, "/posts") or
  starts_with(http.request.uri.path, "/tags") or
  starts_with(http.request.uri.path, "/page/") or
  starts_with(http.request.uri.path, "/about") or
  starts_with(http.request.uri.path, "/now") or
  starts_with(http.request.uri.path, "/uses") or
  starts_with(http.request.uri.path, "/travel") or
  http.request.uri.path eq "/index.xml"
)
```

- **Then:** *Dynamic*, expression `concat("https://kenan.sh", http.request.uri.path)`
- **Status code:** 301
- **Preserve query string:** on

This covers every post, `/posts/`, `/tags/` and all 11 tag pages, the 4 personal pages, Hugo's
`/page/1/` pagination aliases, and the RSS feed at `/index.xml`. It also covers anything under
those prefixes that didn't exist when the list was generated, such as feeds from older builds
(`/posts/index.xml`, `/tags/<tag>/index.xml`) and future posts linked with the old domain.

The host match is exact, so `nightscout.kenanjasim.com` and other subdomains aren't affected. None
of the portfolio's own files use these prefixes (checked against a build).

## 2. Bulk Redirects (account level)

These are for URLs that existed on older versions of the site and don't map 1:1:

| Old | New |
|---|---|
| `/cv/` | `https://kenanjasim.com/` |
| `/projects/` | `https://kenanjasim.com/#projects` |
| `/education/` | `https://kenanjasim.com/#education` |
| `/search/` | `https://kenan.sh/posts/` |
| `/categories/` | `https://kenan.sh/tags/` |
| `/profile.svg` | `https://kenan.sh/profile.svg` |

1. **Manage Account → Configurations → Lists → Create list**. Choose type *Redirect* and a name
   like `kenanjasim_legacy`. Then **Add items → Upload CSV** with `bulk-redirects.csv`.
   The columns are `source_url, target_url, status_code, preserve_query_string, include_subdomains,
   subpath_matching, preserve_path_suffix`, with no header row. Check the preview matches the table
   above.
2. **Rules → Bulk Redirects → Create Bulk Redirect Rule**, using the list above.

If you'd rather not use Bulk Redirects for 6 URLs, add them as extra *Static* Single Redirect rules
instead. They fit easily inside the free plan's 10 rules.

## 3. Other domains

| Zone | Rule |
|---|---|
| kenjasim.com | Already 301s to `https://kenanjasim.com` with the path kept. Leave it as is. |
| kenan.me.uk | Expression `true` → Dynamic `concat("https://kenan.sh", http.request.uri.path)`, 301, preserve query string. It needs proxied DNS records to exist: `A @ 192.0.2.1` and `A www 192.0.2.1`, both proxied (orange cloud). |

## Verify

```bash
./cloudflare/verify-redirects.sh
```
