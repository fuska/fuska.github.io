#descargar el texto de los lniks
#descargar avatares q no tengo ya
#y algo para q si se abren dos tabs a la vez no se descarguen las dos mismas timelines a la vez
#coño, si no necesito macrodroid ni bash para llevarlo al movil! si sonsigo hacer esto con javascript.fetch
#puedo hacer un ifttt q cada vez q un usuario twitte llame a un webhook en php q le pase como argumento el twitter handle y se guarde el timestamp. luego me puedo descargar una página con todos los timestamps y si la fecha de modificación del fichero local es anterior al timestamp, me descargo ese timeline. así los q se actualizan una vez al mes no tengo q descargarlos todas las horas
#tengo q recuperar las ideas q tenía apuntadas: contraer tweets de cansinos, ponerles la letra más grande a los interesantes, imagen de perfil monocromática detras del texto...
#mirar a ver xq hay algunos links q se cierran. RESUELTO (más o menos igual q que ver porque pasaba esto en un principio
#puedo poner un contador de cuantos tweets nuevos se descargan en cada ejecución. Si la media tiende a cero, tengo q poner más interval entre descargas, si la media son más de 10 (por ejemplo) tengo q descargarlos más a menudo. tal vez incluso puede q sea capaz de comentar los if $handler
#recuprar retweets e hilos
#no necesito la api de twitter xa hacer likes, puedo poner un link a un php mio. o a raindrop.io y q funcione offline
#puedo descargar 1 tweet al día de @wondelfulmaps (uno q tenga varios retweets), pintura del siglo 20, etc
#descargar encuestas

updated=0
COUNTER=0
#for myfile in *.txt
#for myfile in `ls -tr jonathanmartinz*.txt ` #loop files sorted from oldest to newest
for myfile in `ls -tr *.txt ` #loop files sorted from oldest to newest
do
	handler=`echo $myfile | awk '{ print substr($1, 1, length($1)-4) }'`
	echo $handler
	#muy util el truco para pasarle el stdout al comando date q no lo permite https://superuser.com/questions/711017/how-do-i-pipe-output-to-date-d-value
	timesince=$(echo `date "+%s"` - `stat -l -t '%F %T' $myfile | awk '{print $6 " " $7}' | { read gmt ; date -j -f "%Y-%m-%d %H:%M:%S" "$gmt" +%s ; }` | bc -l)
	echo $timesince
	#timesince=100000000
	#if [ "$handler" = "jonathanmartinz" ]; then
	#	timesince=100000000
	#fi
	if [ "$handler" = "101touch" ] || [ "$handler" = "augmate" ] || [ "$handler" = "carlosurriza" ] || [ "$handler" = "EQParticipacion" ] || [ "$handler" = "FHIOxford" ] || 
	   [ "$handler" = "ForbesFlauta" ] || [ "$handler" = "fuskabot" ] || [ "$handler" = "GacetaLocal" ] || [ "$handler" = "LarrauriMaite" ] || [ "$handler" = "lasitamar" ] || 
	   [ "$handler" = "luisalegrezahon" ] || [ "$handler" = "ManuelaCarmena" ] || [ "$handler" = "musica6columna" ] || [ "$handler" = "NASAWebb" ] || [ "$handler" = "NewLeftReview" ] || 
	   [ "$handler" = "pmarsupia" ] || [ "$handler" = "Pantomima_Full" ] || [ "$handler" = "PodemosUnido" ] || [ "$handler" = "RobEgea" ] || [ "$handler" = "Stupid__Signs" ] || 
	   [ "$handler" = "tekezo" ] || [ "$handler" = "vestager" ] || [ "$handler" = "viegasf" ] || [ "$handler" = "ViTrend" ] || [ "$handler" = "XArrizabaloM" ] || [ "$handler" = "nelagarnela" ]; then
		interval=600000
	elif [ "$handler" = "4gravitons" ] || [ "$handler" = "CDR_Madrid" ] || [ "$handler" = "ChemaMadoz" ] || [ "$handler" = "CSISAerospace" ] || [ "$handler" = "alvarocarmona" ] || 
	     [ "$handler" = "EticaDemocracia" ] || [ "$handler" = "hersimmar" ] || [ "$handler" = "pabloMP2P" ] || [ "$handler" = "PodemosCarabLat" ] || [ "$handler" = "PostGraphics" ] || 
	     [ "$handler" = "RedRentaBasica" ] || [ "$handler" = "REF_Filosofia" ] || [ "$handler" = "RojasEngein" ] || [ "$handler" = "TerribleMaps" ]; then
		interval=150000
	else
		interval=6000
	fi
	echo $interval
	if [ "$timesince" -gt "$interval" ]; then
		curl https://twitter.com/$handler | grep -E 'data-permalink-path|TweetTextSize|data-time|data-tweet-stat-count' | sed -E 's/(.*)data-tweet-stat-count(=\"|=\"([0-9]*))\">/|\3|/g'  | sed -E 's/(.*)data-time=\"([0-9]+)(.*)/\2|/g' | sed 's/<span.*/link<\/a>/ ' | sed 's/.*">// ' | sed 's/"$/|'$handler'|/g' | tr -d '\n' | sed 's/<\/p>/|/g' | sed $'s/data-permalink-path=\"/\\\n/g ' | sed 's/||/|/g' > $handler.txt
		COUNTER=$((COUNTER+1))

		while read line #si quiero el orden cronológico ascendente sería un tac
		do
#		echo $line
			id=`echo $line | cut -f1 -d'|' | cut -f4 -d'/'`
			#echo .$id
			if [ ! -z "$id"  ]; then #quitar líneas vacías
			
			    timestamp=`echo $line | cut -f3 -d'|'`
			    timedif=$(echo `date "+%s"` - $timestamp | bc -l)
			    #echo $timedif
			    
			    if [ "$timedif" -lt "4000000" ]; then #solo los tweets de menos de dos meses
			
#					echo ooooo $id
					cat agosto.html | grep $id 	> /dev/null
					if [ $? -ne 0 ];then    #si no está ya en el fichero lo vamos a añadir
					
						updated="x"
					
					#echo hooooola
					#echo $id
					#echo $line | sed 's/^/<div id=\"link">/'  | sed 's/\|/<\/div><div id=\"handle">/' | sed 's/\|/<\/div><div id=\"timestamp">/' | sed 's/\|/<\/div><br \/><div id=\"text">/'  | sed 's/\|/<\/div><br \/><div><span id=\"replies">/' | sed 's/\|/<\/span>-<span id=\"likes">/' | sed 's/\|/<\/span>-<span id=\"retweets">/' | sed 's/\|/<\/span></div><br \/>/'

						line=`echo $line | sed 's/^/<div class="row"><span class="col2"><span class="header"><div class=\"link">/' | sed 's/\|/<\/div><span class=\"handle">/' | sed 's/\|/<\/span><div class=\"timestamp">/' | sed 's/\|/<\/div><\/span><br \/><span class=\"text">/'  | sed 's/\|/<\/span><br \/><\/div><\/span><div><span class=\"replies">/' | sed 's/\|/<\/span> 💬  <span class=\"retweets">/' | sed 's/\|/<\/span> 🚀  <span class=\"likes">/' | sed 's/\|/<\/span> 💜  <\/div><br \/>/' `

					
						if [[ $line = *"pic.twitter.com/"* ]]; then

							myimg=$(curl -sL `echo $line | grep -o "pic.twitter.com/.*<" | awk '{ print substr($1 , 1 , length ($1)-13 ) }'` | grep 'property="og:image"' | awk '{ print substr ($3, 10, length ($3)-11) }' | tr '\n' '|' | awk '{ print substr ($1, 1, length ($1)-1) }' | sed 's/|/\"><img src=\"/g')
							echo $myimg
							#echo $line | sed 's/pic.twitter.com\/[A-Z]{10}/<img src=\"'$myimg'\">/g' >> agosto
							echo $line | sed "s|pic.twitter.com...........|<br /><img src=\"$myimg\">|g" >> agosto.html
						else
							echo $line >> agosto.html
						fi
					fi	
				fi
			fi
		done < $myfile  #Esto vale para pasarle el contenido de $myfile al while y poder utilizar el flag $updated https://serverfault.com/questions/259339/bash-variable-loses-value-at-end-of-while-read-loop
	fi
	if [ "$COUNTER" -eq "1" ]; then
		break
	fi
done

	updated="x"
if [ "$updated" = "x" ];then
  
	curl -X POST https://content.dropboxapi.com/2/files/upload \
    --header "Authorization: Bearer vN2wQT04JsMAAAAAAAADpBGeNSU2FpvPHHb5UR0j_jdE9_bePr4jEZwhIbpOmnVj" \
    --header "Dropbox-API-Arg: {\"path\": \"/Aplicaciones/KISSr/fuska.kissr.com/agosto2.html\",\"mode\": \"overwrite\"}" \
    --header "Content-Type: application/octet-stream" \
    --data-binary @agosto.html
    echo `date "+%s"` > `date "+%s"`.txt
fi

#    --header "Dropbox-API-Arg: {\"path\": \"/Aplicaciones/updog/fuska/agosto.html\",\"mode\": \"overwrite\"}" \
#http://fuska.kissr.com/agosto.html


#for i in *.txt; do handler=`echo $i | awk '{ print substr($1, 1, length($1)-4) }'`; curl `curl -s https://twitter.com/"$handler" | grep js-action-profile-avatar | head -n1 | awk '{ print substr ( $4 , 6, length ($4)-6 ) }'` -o avatars/$handler.jpeg; done



#https://twitter.com/k0rsika__/with_replies

#no hace falta hacer un sort by tweet-id. a partir del segundo día, se irán añadiendo tweets por orden cronológico pero con dos ventajas: ligueramente agrupados por usuario y nunca voy a perder un tweet q "entre" en mi fichero tarde
#cat following| while read p; do curl https://twitter.com/$p | grep -E 'data-tweet-id|TweetTextSize' | sed 's/data-tweet-id=\"//g ' | sed 's/.*">// ' | sed 's/"$/;'$p';/g' | tr -d '\n' | sed $'s/<\/p>/\\\n/g' > $p.txt ; sleep 100 ; done
#cat following| while read p; do curl https://twitter.com/$p | grep -E 'data-permalink-path|TweetTextSize|data-time' | sed -E 's/(.*)data-time=\"([0-9]+)(.*)/\2|/g' | sed 's/<span.*// ' | sed 's/.*">// ' | sed 's/"$/|'$p'|/g' | tr -d '\n' | sed $'s/<\/p>/\\\n/g' | sed $'s/data-permalink-path=\"/\\\n/g ' > $p.txt ; sleep 100 ; done
#cat following| while read p; do curl https://twitter.com/$p | grep -E 'data-permalink-path|TweetTextSize|data-time|data-tweet-stat-count' | sed -E 's/(.*)data-tweet-stat-count(=\"|=\"([0-9]*))\">/|\3|/g'  | sed -E 's/(.*)data-time=\"([0-9]+)(.*)/\2|/g' | sed 's/<span.*/link<\/a>/ ' | sed 's/.*">// ' | sed 's/"$/|'$p'|/g' | tr -d '\n' | sed 's/<\/p>/|/g' | sed $'s/data-permalink-path=\"/\\\n/g ' | sed 's/||/|/g' > $p.txt ; sleep 100 ; done