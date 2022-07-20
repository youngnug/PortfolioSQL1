--This is SQL exploring the `bigquery-public-data.baseball.games_post_wide` dataset. I transferred copies to my own personal testing-project-340107 dataset so I didn't
--have to worry about permissions as much. If you ctrl H and replace 'testing-project-340107' with `bigquery-public-data' these can be run.
--Fastest pitchers in the Playoffs

SELECT 
   ROUND(AVG(pitchspeed),1) AS avg_speed,COUNT(pitcherid) as numofpitches, pitcherLastName,pitcherfirstname
FROM 
    `testing-project-340107.baseball.games_post_wide` 
WHERE 
    pitcherLastName <> ''
GROUP BY 
    pitcherLastName, pitcherfirstname
HAVING
    numofpitches>100
ORDER BY 
    avg_speed DESC 
    
    
--Fastest pitchers for Red Sox in the playoffs
SELECT 
   ROUND(AVG(pitchspeed),1) AS avg_speed,pitcherLastName, pitcherfirstname
FROM 
    `testing-project-340107.baseball.games_post_wide` 
WHERE 
    venuestate = 'MA' AND pitcherLastName <> ''
GROUP BY 
    pitcherLastName, pitcherfirstname
ORDER BY 
    avg_speed DESC


--Average pitch speed for lefty pitchers
/*
SELECT 
   ROUND(AVG(pitchspeed),1) AS avg_speed, COUNT(pitcherid) as numofpitches ,pitcherLastName, pitcherfirstname, pitcherThrowHand
FROM 
    `testing-project-340107.baseball.games_post_wide` 
WHERE 
    pitcherLastName <> '' AND pitcherThrowHand = 'L'
GROUP BY 
    pitcherLastName, pitcherfirstname,pitcherThrowHand
HAVING
    numofpitches>100
ORDER BY 
    avg_speed DESC


--Average pitch speed for righty pitchers
/*
SELECT 
   ROUND(AVG(pitchspeed),1) AS avg_speed,COUNT(pitcherid) as numofpitches, pitcherLastName, pitcherfirstname, pitcherThrowHand
FROM 
    `testing-project-340107.baseball.games_post_wide` 
WHERE 
    pitcherLastName <> '' AND pitcherThrowHand = 'R'
GROUP BY 
    pitcherLastName, pitcherfirstname,pitcherThrowHand
HAVING
    numofpitches>100
ORDER BY 
    avg_speed DESC


-- Number of lefty and righty pitchers. I do not have this controlled for pitches who have thrown at least 100 pitches because I wanted to see difference in its entirety.
/*
SELECT pitcherthrowhand,
    
    COUNT(DISTINCT(pitcherid)) AS NumberofPitchers
FROM 
    testing-project-340107.baseball.games_post_wide
GROUP BY 
    pitcherthrowhand
HAVING 
    pitcherthrowhand != '' 


--Using # of pitchers to get average type of pitch thrown per game by lefty and righty pitchers
-- Right handed pitchers variation
/*
SELECT 
    COUNT(pitchtypedescription)/65 AS thrownpergame,pitcherthrowhand, pitchtypedescription
FROM 
    testing-project-340107.baseball.games_post_wide
group by 
    pitchTypeDescription, pitcherthrowhand
HAVING 
    pitcherthrowhand != '' AND pitchtypedescription != '' AND pitcherthrowhand = 'R' 
ORDER BY 
    pitchTypeDescription


--Left handed pitchers variation
SELECT 
    COUNT(pitchtypedescription)/32 AS righty_thrown_pergame,pitcherthrowhand, pitchtypedescription
FROM 
    testing-project-340107.baseball.games_post_wide
group by 
    pitchTypeDescription, pitcherthrowhand
HAVING 
    pitcherthrowhand != '' AND pitchtypedescription != '' AND pitcherthrowhand = 'L'
ORDER BY 
    pitchTypeDescription


--Idk why this took me so long but I'm happy with this table
SELECT
    CASE WHEN pitcherthrowhand = 'R' THEN COUNT(pitchtypedescription)/65 END AS righty_thrown_pergame,
    CASE WHEN pitcherthrowhand = 'L' THEN COUNT(pitchtypedescription)/32 END AS Lefty_thrown_pergame, pitcherthrowhand, pitchtypedescription
FROM 
    testing-project-340107.baseball.games_post_wide
group by 
    pitchTypeDescription, pitcherthrowhand
HAVING 
    pitcherthrowhand != '' AND pitchtypedescription != ''
ORDER BY 
    pitchTypeDescription


--most strikeouts by pitchers in the playoffs
SELECT 
    COUNT(strikes) AS strike_outs, pitcherLastName,pitcherfirstname,pitcherthrowhand FROM testing-project-340107.baseball.games_post_wide
WHERE 
    strikes = 3 AND pitcherlastname != ''
GROUP BY 
    pitcherLastName, pitcherfirstname, pitcherthrowhand
ORDER BY 
    count(strikes) DESC
LIMIT 30

--strikeouts by righy and lefty players per game
SELECT 
    CASE WHEN pitcherthrowhand = 'R' THEN COUNT(strikes)/65 END AS strike_outspergame, 
    CASE WHEN pitcherthrowhand = 'L' THEN count(strikes)/32 END as strike_outspergame, pitcherthrowhand 
FROM 
    testing-project-340107.baseball.games_post_wide
WHERE 
    strikes = 3 AND pitcherlastname != ''
GROUP BY 
    pitcherthrowhand
    
    
--Which types of pitches earned the most strikes
SELECT 
    sum(strikes) AS total_strikes, pitchTypeDescription, 
FROM 
    testing-project-340107.baseball.games_post_wide
GROUP BY 
    pitchTypeDescription
HAVING 
    pitchTypeDescription != ''
ORDER BY 
    sum(strikes) DESC
    
--Which type of pitches earned the most balls
SELECT 
    sum(balls) AS total_balls, pitchTypeDescription, 
FROM 
    testing-project-340107.baseball.games_post_wide
GROUP BY 
    pitchTypeDescription
HAVING 
    pitchTypeDescription != ''
ORDER BY 
    sum(balls) DESC
    
--Why not do a join with regular season data as well
SELECT 
    ROUND(avg(regseason.pitchspeed),1) AS totalavgpitchspeed, postseason.pitcherlastname,postseason.pitcherfirstname, 
FROM 
    testing-project-340107.baseball.games_post_wide as postseason
JOIN 
    testing-project-340107.baseball.games_wide as regseason
ON 
    postseason.pitchspeed =regseason.pitchspeed
GROUP BY 
    postseason.pitcherlastname, postseason.pitcherfirstname
HAVING 
    pitcherlastname != '' 
ORDER BY 
    totalavgpitchspeed DESC
--Can use this to compare playoff pitch speed to entire season including playoffs. Since this is an inner join, pitchers who did not make the playoffs are excluded.
