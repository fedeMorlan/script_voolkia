#!/bin/bash


SITE_ID="MLA"
# para acceder a varios usuarios sellers (notar que se van a imprimir usuarios vacíos)
SELLER_IDS=("179571326" "" "" "")

# para el archivo de volcado
log=""

for seller in "${SELLER_IDS[@]}"
do
  log+="SELLER ID: ${seller}\n"
  resultados=$(curl -X GET -H 'Authorization: Bearer $ACCESS_TOKEN' https://api.mercadolibre.com/sites/"${SITE_ID}"/search?seller_id="${seller}" | jq -r ".results[]")
  # en la clave "results" hay una lista con varios diccionarios, cada uno es un producto
  # cada producto contiene campos id, title y category_id
  
  # se recorre cada item guardando lo solicitado en variables para pasarlas al log

  idsItem=($(echo "${resultados}" | jq -r ".id"))
  titlesItem=$(echo "${resultados}" | jq -r ".title")
  idsCatItem=($(echo "${resultados}" | jq -r ".category_id"))
  # para separar un string por salto de linea, porque se necesita guardar cada elemento del titlesItem que tiene espacios en su string
  IFS=$'\n'
  arrTitles=($(echo "${titlesItem}"))
  

  for i in "${!idsItem[@]}"; do
    # el nombre de la categoria no esta en el item, hay que buscarlo aparte
    # esta parte en linux funciona bien, no termino de entender qué cambia en windows
    nameCatItem=$(curl -s https://api.mercadolibre.com/categories/"${idsCatItem[$i]}" | jq -r ".name")
    log+="ID: ${idsItem[$i]}; title: ${arrTitles[$i]}; category_id: ${idsCatItem[$i]}; catName: ${nameCatItem}\n"
  done  
  log+="\n"

done

echo -e "${log}" > log.txt

exit 0