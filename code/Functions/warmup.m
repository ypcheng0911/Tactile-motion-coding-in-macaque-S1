
% Script warmup.m loads SingleUnit, RecordingSite, Subject object formats.

a = SingleUnit('warmup',[],[],[],[],[],[],[],[],[],[],[],[],[]);
b = RecordingSite('warmup',[],{a});
c = Subject('warmup',[],[],[],[],{b});
d = BrainArea('warmup',a);
e = SUresult('warmup','warmup',[],[]);
clear
clc