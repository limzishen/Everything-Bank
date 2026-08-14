# Pandas Cheat Sheet (for SQL people)

`df` = table. Index = ordered/labeled row IDs (no SQL equivalent) — ops align on it.

## Select / Filter

|SQL|pandas|
|---|---|
|`SELECT a, b`|`df[['a','b']]`|
|`SELECT *`|`df`|
|`WHERE x > 5`|`df[df.x > 5]`|
|`WHERE x>5 AND y=1`|`df[(df.x>5) & (df.y==1)]` — parens + `&`/`\|`/`~`|
|`WHERE x IN (1,2)`|`df[df.x.isin([1,2])]`|
|`WHERE x NOT IN (1,2)`|`df[~df.x.isin([1,2])]`|
|`WHERE x IS NULL`|`df[df.x.isna()]`|
|`WHERE x IS NOT NULL`|`df[df.x.notna()]`|
|`ORDER BY x DESC`|`df.sort_values('x', ascending=False)`|
|`LIMIT 10`|`df.head(10)`|

## .loc vs .iloc → always `[rows, cols]`

- `.loc` = **by label**, slice endpoint **inclusive**
- `.iloc` = **by integer position**, slice endpoint **exclusive**

```python
df.loc[df.y == v, 'x']          # SELECT x WHERE y = v  (Series)
df.loc[df.y == v, ['x','y']]    # multiple cols  (DataFrame) — cols in a LIST
df.iloc[0:2, 0]                 # rows 0,1 / col 0
```

Assign through a **single** `.loc` — never chained `df[m]['x']=...` (copy trap):

```python
df.loc[df.y > 0, 'x'] = 1       # UPDATE SET x=1 WHERE y>0
```

## Distinct

```python
df['x'].unique()          # → array
df['x'].drop_duplicates() # → Series
df.drop_duplicates(subset=['x','y'])   # distinct rows
df['x'].nunique()         # COUNT(DISTINCT x)
```

## Aggregate / Group (split-apply-combine)

```python
df.groupby('k').v.sum()
df.groupby('k').agg(n=('v','size'), avg=('v','mean'))   # named aggs
df.groupby('k').v.sum().loc[lambda s: s>10]             # HAVING
```

- Output keys land on the **index** → add `.reset_index()` for a flat table.
- `groupby` **drops NaN keys by default** (`dropna=True`) — silent row loss.

## Window functions (keep row count)

```python
df.groupby('k').transform('mean')   # OVER (PARTITION BY k)
df.groupby('k').cumcount()          # ROW_NUMBER()
df.groupby('k').v.cumsum()          # running SUM
```

`transform` keeps rows; `agg` collapses them.

## Join / Combine

```python
a.merge(b, on='k')                    # INNER (default)
a.merge(b, on='k', how='left')        # LEFT (also 'right','outer')
pd.concat([a,b])                      # UNION ALL
pd.concat([a,b]).drop_duplicates()    # UNION
```

## New / Derived column (SELECT expr AS z)

```python
df.assign(z=df.x * 2)                 # returns new frame (chain-friendly)
df['z'] = df.x * 2                    # in place
df['z'] = np.where(df.x>5,'hi','lo')  # CASE WHEN (2-way)
df['z'] = np.select([df.x>5, df.x>0], ['hi','mid'], default='lo')   # n-way
df['z'] = df.apply(lambda r: f(r.x,r.y), axis=1)   # row-wise, SLOW — last resort
```

`.assign(name=expr)` uses `=` and needs a name. Expressions are vectorized (C-speed).

## Rename

```python
df.rename(columns={'old':'new'})      # SELECT old AS new  (ignores unknown keys)
df.columns = ['a','b','c']            # replace ALL by position
```

`.assign` does NOT rename — it copies under a new name.

## Convert dtype (CAST)

```python
df['x'] = df['x'].astype('int64')      # or 'float64','category','string'
df = df.astype({'x':'int64','y':'float64'})
pd.to_numeric(df.x, errors='coerce')   # bad → NaN instead of raising
pd.to_datetime(df.x)
```

- Plain `int64` **can't hold NaN** → use nullable `'Int64'` (capital I).
- `'string'` (nullable, Arrow) > `'str'` (object) in new code.

## Nulls (NaN / None / NaT all count)

```python
df.x.isna() / df.x.notna()
df['x'] = df['x'].fillna(0)                 # replace nulls
df = df.fillna({'x':0, 'y':'unknown'})
df.dropna(subset=['x'])                     # drop rows null in x
```

- `''` and `0` are NOT null → use `.replace('', 0)`.
- Filling float col with `0` gives `0.0` → `.astype('int64')` after if needed.

## Perf traps

- Vectorize; avoid `.apply(axis=1)` / `.iterrows()` (Python loop, 10–100× slower).
- `object` dtype = slow/heavy → cast repeated strings to `category`.
- Building rows in a loop with `concat`/`append` = quadratic → collect in a list, `concat` once.
- No query planner — eager, top-to-bottom. Filter before expensive ops yourself.
- Single-threaded, RAM-hungry (~5–10× data size). Large/parallel → Polars, DuckDB, Dask.