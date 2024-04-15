--Poltiquette Telephantom
--Scripted by Beanbag
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	Fusion.AddProcMixRep(c,false,false,s.ffilter,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3D4),2,2)
end
s.listed_series={0x3D4}
s.material_setcode={0x3D4}
function s.ffilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x3D4,fc,sumtype,tp) and c:IsType(TYPE_TRAP+TYPE_SPELL,fc,sumtype,tp)
end