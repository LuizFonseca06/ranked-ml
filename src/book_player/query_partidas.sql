--drop table if exists tb_book_players;

--create table  tb_book_players as
with tb_lobby as (select *
                  from tb_lobby_stats_player
                  where dtCreatedAt < '{date}'
                    and dtCreatedAt > date('{date}', '-30 day')),
     tb_stats as (select idPlayer,
                         count(distinct idLobbyGame)                                                as qtPartidas,
                         count(distinct date(dtCreatedAt))                                          as qtDias,
                         count(distinct case when qtRoundsPlayed < 16 then idLobbyGame end)         as qtPartidasMenos16,
                         min(julianday('{date}') - julianday(dtCreatedAt))                      as qtDiasUltimaLobby,
                         1.0 * count(distinct idLobbyGame) / count(distinct date(dtCreatedAt))      as mediaPartidasDia,
                         avg(qtKill)                                                                as avgQtKill,
                         avg(qtAssist)                                                              as avgQtAssist,
                         avg(qtDeath)                                                               as avgQtDeath,
                         avg(1.0 * (qtKill + qtAssist) / qtDeath)                                   as avgKDA,
                         1.0 * sum(qtKill + qtAssist) / sum(qtDeath)                                as KDAgeral,
                         avg(1.0 * (qtKill + qtAssist) / qtRoundsPlayed)                            as avgKARound,
                         1.0 * sum(qtKill + qtAssist) / sum(qtRoundsPlayed)                         as KARoundGeral,
                         avg(qtHs)                                                                  as avgQtHs,
                         avg(1.0 * qtHs / qtKill)                                                   as avgHsRate,
                         1.0 * sum(qtHs) / sum(qtKill)                                              as txHsGeral,
                         avg(qtBombeDefuse)                                                         as avgQtBombeDefuse,
                         avg(qtBombePlant)                                                          as avgQtBombePlant,
                         avg(qtTk)                                                                  as avgQtTk,
                         avg(qtTkAssist)                                                            as avgQtTkAssist,
                         avg(qt1Kill)                                                               as avgQt1Kill,
                         avg(qt2Kill)                                                               as avgQt2Kill,
                         avg(qt3Kill)                                                               as avgQt3Kill,
                         sum(qt4Kill)                                                               as sumQt4Kill,
                         avg(qt4Kill)                                                               as avgQt4Kill,
                         sum(qt5Kill)                                                               as sumQt5Kill,
                         avg(qt5Kill)                                                               as avgQt5Kill,
                         avg(qtPlusKill)                                                            as avgQtPlusKill,
                         avg(qtFirstKill)                                                           as avgQtFirstKill,
                         avg(vlDamage)                                                              as avgVlDamage,
                         avg(1.0 * vlDamage / qtRoundsPlayed)                                       as avgVlDamageRound,
                         1.0 * sum(vlDamage) / sum(qtRoundsPlayed)                                  as DamageRoundGeral,
                         avg(qtHits)                                                                as avgQtHits,
                         avg(qtShots)                                                               as avgQtShots,
                         avg(qtLastAlive)                                                           as avgQtLastAlive,
                         avg(qtClutchWon)                                                           as avgQtClutchWon,
                         avg(qtRoundsPlayed)                                                        as avgQtRoundsPlayed,
                         avg(vlLevel)                                                               as avgVlLevel,
                         avg(qtSurvived)                                                            as avgQtSurvived,
                         avg(qtTrade)                                                               as avgQtTrade,
                         avg(qtFlashAssist)                                                         as avgQtFlashAssist,
                         avg(qtHitHeadshot)                                                         as avgQtHitHeadshot,
                         avg(qtHitChest)                                                            as avgQtHitChest,
                         avg(qtHitStomach)                                                          as avgQtHitStomach,
                         avg(qtHitLeftAtm)                                                          as avgQtHitLeftAtm,
                         avg(qtHitRightArm)                                                         as avgQtHitRightArm,
                         avg(qtHitLeftLeg)                                                          as avgQtHitLeftLeg,
                         avg(qtHitRightLeg)                                                         as avgQtHitRightLeg,
                         avg(flWinner)                                                              as avgFlWinner,
                         count(distinct case when descMapName = "de_mirage" then idLobbyGame end)   as qtDe_mirage,
                         count(distinct case
                                            when descMapName = "de_mirage" and flWinner = 1
                                                then idLobbyGame end)                               as qtVitoriasDe_mirage,
                         count(distinct case when descMapName = "de_nuke" then idLobbyGame end)     as qtDe_nuke,
                         count(distinct case
                                            when descMapName = "de_nuke" and flWinner = 1
                                                then idLobbyGame end)                               as qtVitoriasDe_nuke,
                         count(distinct case when descMapName = "de_inferno" then idLobbyGame end)  as qtDe_inferno,
                         count(distinct case
                                            when descMapName = "de_inferno" and flWinner = 1
                                                then idLobbyGame end)                               as qtVitoriasDe_inferno,
                         count(distinct case when descMapName = "de_vertigo" then idLobbyGame end)  as qtDe_vertigo,
                         count(distinct case
                                            when descMapName = "de_vertigo" and flWinner = 1
                                                then idLobbyGame end)                               as qtVitoriasDe_vertigo,
                         count(distinct case when descMapName = "de_ancient" then idLobbyGame end)  as qtDe_ancient,
                         count(distinct case
                                            when descMapName = "de_ancient" and flWinner = 1
                                                then idLobbyGame end)                               as qtVitoriasDe_ancient,
                         count(distinct case when descMapName = "de_dust2" then idLobbyGame end)    as qtDe_dust2,
                         count(distinct case
                                            when descMapName = "de_dust2" and flWinner = 1
                                                then idLobbyGame end)                               as qtVitoriasDe_dust2,
                         count(distinct case when descMapName = "de_train" then idLobbyGame end)    as qtDe_train,
                         count(distinct case
                                            when descMapName = "de_train" and flWinner = 1
                                                then idLobbyGame end)                               as qtVitoriasDe_train,
                         count(distinct case when descMapName = "de_overpass" then idLobbyGame end) as qtDe_overpass,
                         count(distinct case
                                            when descMapName = "de_overpass" and flWinner = 1
                                                then idLobbyGame end)                               as qtVitoriasDe_overpass


                  from tb_lobby

                  group by idPlayer),

     tb_lvl_atual as (select idPlayer, vlLevel
                      from (select idLobbyGame,
                                   idPlayer,
                                   vlLevel,
                                   dtCreatedAt,
                                   row_number() over (PARTITION by idPlayer order by dtCreatedAt desc) as rn

                            from tb_lobby)

                      where rn = 1),

     tb_book_lobby as (select t1.*,
                              t2.vlLevel as vlLevelAtual
                       from tb_stats as t1
                                left join tb_lvl_atual as t2
                                          on t1.idPlayer = t2.idPlayer),

     tb_medals as (select *
                   from tb_players_medalha t2
                            left join tb_medalha as t1
                                      on t1.idMedal = t2.idMedal
                   where (dtCreatedAt < dtExpiration)
                     and (dtCreatedAt < '{date}')
                     and (coalesce(dtRemove, dtExpiration) > date('{date}', '-30 day'))),
     tb_book_medal as (select idPlayer,
                              count(distinct tb_medals.idMedal)                                        as qtMedalhaDist,
                              count(case when dtCreatedAt > date('{date}', '-30 day') then id end) as qtMedalhaAdquiridas,
                              sum(case when descMedal = 'Membro Premium' then 1 else 0 end)            as qtPremium,
                              sum(case when descMedal = 'Membro Plus' then 1 else 0 end)               as qtPlus,
                              max(case
                                      when descMedal in ('Membro Premium', 'Membro Plus')
                                          and coalesce(dtRemove, dtExpiration) >= '{date}'
                                          then 1
                                      else 0 end
                                  )                                                                    as assinaturaAtiva
                       from tb_medals
                       group by idPlayer)

insert into tb_book_players

select '{date}'                                                 as dtRef,
       t1.*,
       coalesce(t2.qtMedalhaDist, 0)                                as qtMedalhaDist,
       coalesce(t2.qtMedalhaAdquiridas, 0)                          as qtMedalhaAdquiridas,
       coalesce(t2.qtPremium, 0)                                    as qtPremium,
       coalesce(t2.qtPlus, 0)                                       as qtPlus,
       coalesce(t2.assinaturaAtiva, 0)                              as assinaturaAtiva,
       t3.flFacebook,
       t3.flTwitter,
       t3.flTwitch,
       t3.descCountry,
       t3.dtBirth,
       ((julianday('{date}')) - julianday(t3.dtBirth)) / 365.25 as vlIdade,
       ((julianday('{date}')) - julianday(t3.dtRegistration))   as vlDiasCadastro,
       t3.dtRegistration
from tb_book_lobby as t1
         left join
     tb_book_medal as t2
     on t1.idPlayer = t2.idPlayer
         left join tb_players as t3
                   on t1.idPlayer = t3.idPlayer