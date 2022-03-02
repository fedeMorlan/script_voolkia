import requests

site_id = 'MLA'
seller_ids = [179571326]
archivo = open('log.txt', 'w', encoding='utf-8')

for seller in seller_ids:
    req = requests.get(f"https://api.mercadolibre.com/sites/{site_id}/search?seller_id={seller}")
    lista = req.json()
    resultados = lista['results']
    for item in resultados:
        id = item['id']
        title = item['title']
        category_id = item['category_id']
        categoria = requests.get(f"https://api.mercadolibre.com/categories/{category_id}")
        categoria = categoria.json()
        cat_name = categoria["name"]
        archivo.write (f'itemID: {id}; '
               f'itemTitle:{title}; '
               f'itemCategoryID:{category_id}; '
               f'categoryName:{cat_name}; \n')

archivo.close()

