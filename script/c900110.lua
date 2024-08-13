--Magmalith Volcanthis
--scripted by Beanbag
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Fusion summon/contact fusion procedure
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(s.matfilter),2,aux.FilterBoolFunctionEx(s.matfilter2),1)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
end

function s.matfilter(c,fc,st,tp)
	return c:IsSetCard(0x385) and not c:IsType(TYPE_XYZ)
end
function s.matfilter2(c,fc,st,tp)
	return c:IsRace(RACE_ROCK) and c:IsType(TYPE_XYZ)
end
function s.contactfil(tp)
	return Duel.GetReleaseGroup(tp)
end
function s.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end