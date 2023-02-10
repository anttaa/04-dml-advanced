-- количество исполнителей в каждом жанре;
select g.title, count(g.title)
from genry g left join genry_artist ga on (g.id = ga.genry_id)
group by g.title


-- количество треков, вошедших в альбомы 2019-2020 годов;
select count(a.title)
from album a left join track t ON (a.id = t.album_id)
where a."year" between 2019 and 2020


-- средняя продолжительность треков по каждому альбому;
select a.title, avg(t.duration)
from album a left join track t ON (a.id = t.album_id)
group by a.title


-- все исполнители, которые не выпустили альбомы в 2020 году;
select a2."name"  
from artist a2 
where id not in(
	select DISTINCT aa.artist_id 
	from album a left join artist_album aa on (a.id = aa.id)
	where a."year" = 2020
)


-- названия сборников, в которых присутствует конкретный исполнитель (выберите сами);
select DISTINCT c.title 
from collection c left join collection_track ct on (c.id = ct.collection_id)
left join track t on (t.id = ct.track_id)
left join artist_album aa on (t.album_id = aa.album_id)
left join artist a2 on (a2.id = aa.artist_id)
where a2."name" = 'КИНО'


-- название альбомов, в которых присутствуют исполнители более 1 жанра;
select a.title
from album a left join artist_album aa on (a.id= aa.album_id)
left join artist a2 on (aa.artist_id = a2.id)
left join genry_artist ga on (a2.id = ga.artist_id)
left join genry g on (g.id = ga.genry_id)
group by a.title 
having count(distinct g.title) > 1;


-- наименование треков, которые не входят в сборники;
select distinct t.title 
from track t left join collection_track ct on (t.id = ct.track_id)
where ct.id is Null


-- исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);
select a."name" 
from artist a left join artist_album aa on (a.id = aa.artist_id)
left join track t2 on (t2.album_id = aa.album_id) 
where t2.duration = (
	select min(t.duration)
	from track t 
)


-- название альбомов, содержащих наименьшее количество треков.
select a.title, count(t.title) track_count 
from album as a left join track as t on a.id = t.album_id
group by a.id
having count(t.title) = (
	select count(t.title) 
	from album as a left join track as t on a.id = t.album_id
	group by a.id
	order by count(t.title)
	limit 1
);