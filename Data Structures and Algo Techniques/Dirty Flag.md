If you need to delete multiple values in the an array, it can be very costly
You just dirty flag the value if you dont want it anymore 

```
from collections import defaultdict, deque

def solve(Product, Q, Demand):
    # product_data[type] = [deque_for_filter_1, deque_for_filter_2]
    product_data = {}
    sold = set()

    # Group products by type
    grouped = defaultdict(list)
    for i, (price, rating, typ) in enumerate(Product):
        grouped[typ].append((price, rating, i))

    # Build sorted lists then convert to deque
    for typ, items in grouped.items():
        list1 = sorted(items, key=lambda x: (-x[1], x[0])) 
        list2 = sorted(items, key=lambda x: (x[0], -x[1]))  
        
        product_data[typ] = [
            deque(list1),  # filter 1
            deque(list2),  # filter 2
        ]

    ans = []

    for ftype, typ in Demand:
        # If no products of that type exist
        if typ not in product_data:
            ans.append(-1)
            continue

        dq = product_data[typ][0 if ftype == 1 else 1]

        # Clean dirty items at the front
        while dq and dq[0][2] in sold:
            dq.popleft()   # O(1)

        if not dq:
            ans.append(-1)
            continue

        price, rating, uid = dq.popleft()  # take the best product
        sold.add(uid)
        ans.append(price)

    return ans
```