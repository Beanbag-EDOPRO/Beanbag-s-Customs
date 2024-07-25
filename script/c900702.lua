local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3D),2,2,Synchro.NonTunerEx(Card.IsSetCard,0x3D),1,99)
end