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
	select aa.artist_id 
	from album a left join artist_album aa on (a.id = aa.id)
	where a."year" = 2020
	group by aa.artist_id 
)

-- названия сборников, в которых присутствует конкретный исполнитель (выберите сами);
select c.title 
from collection c left join collection_track ct on (c.id = ct.collection_id)
left join track t on (t.id = ct.track_id)
left join artist_album aa on (t.album_id = aa.album_id)
left join artist a2 on (a2.id = aa.artist_id)
where a2."name" = 'КИНО'
group by c.title

-- название альбомов, в которых присутствуют исполнители более 1 жанра;
select a.title
from album a left join artist_album aa on (a.id= aa.album_id)
where aa.artist_id in (
	select ga.artist_id
	from genry_artist ga 
	group by ga.artist_id
	having count(*) > 1
)
group by a.title 

-- наименование треков, которые не входят в сборники;
select title
from track
where id not in (select track_id from collection_track)

-- исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);
select a."name" 
from artist a left join artist_album aa on (a.id = aa.artist_id)
left join track t2 on (t2.album_id = aa.album_id) 
where t2.duration = (
	select min(t.duration)
	from track t 
)

-- название альбомов, содержащих наименьшее количество треков.
select album_id, count(album_id) as cnt
from track t1 
group by t1.album_id
having count(t1.album_id) = (
	select min(a.cnt)
	from 
		(select count(album_id) as cnt
		from track t 
		group by t.album_id) as a)