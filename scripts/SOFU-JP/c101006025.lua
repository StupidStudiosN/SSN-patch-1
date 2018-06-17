--混源龍レヴィオニア
--Levionia the Primordial Chaos Dragon
--Script by dest
function c101006025.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101006025,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101006025.spcon)
	e1:SetOperation(c101006025.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	e1:SetLabelObject(e2)
	--Destroy/Shuffle/Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101006025)
	e2:SetLabel(0)
	e2:SetCondition(c101006025.descon)
	e2:SetTarget(c101006025.destg)
	e2:SetOperation(c101006025.desop)
	c:RegisterEffect(e2)
end
function c101006025.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c101006025.spcon(e,c)
	if c==nil then return true end
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c101006025.spcostfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c101006025.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101006025.spcostfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) then
		e:GetLabelObject():SetLabel(e:GetLabelObject():GetLabel()+1)
	end
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) then
		e:GetLabelObject():SetLabel(e:GetLabelObject():GetLabel()+2)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101006025.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+1)
end
function c101006025.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101006025.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==1 then
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(c101006025.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		elseif e:GetLabel()==2 then
			return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		else
			return true
		end
	end
	if e:GetLabel()==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(101006025,1))
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(101006025,2))
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(101006025,3))
		e:SetCategory(CATEGORY_DESTROY)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c101006025.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	if e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101006025.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif e:GetLabel()==2 then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<=0 then return end
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
	else
		local g3=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g3:GetCount()>0 then
			local ct=math.min(g3:GetCount(),2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
