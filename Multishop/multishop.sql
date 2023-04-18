select * from member;

update member set mstate = 9 where idx =6;
update member set mstate = -1 where idx =4;
update member set mstate = -2 where idx =5;

commit;

select member.*, 
decode(mstate,0,'활동회원',-1,'정지회원',-2,'탈퇴회원',9,'관리자') mstateStr from member 
order by idx desc;

update member set addr2='2번지' where idx =2;