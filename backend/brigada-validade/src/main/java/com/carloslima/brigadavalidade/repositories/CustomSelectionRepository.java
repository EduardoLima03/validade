package com.carloslima.brigadavalidade.repositories;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;

import org.springframework.stereotype.Repository;

import com.carloslima.brigadavalidade.models.RegisterModel;

@Repository
public class CustomSelectionRepository {

	private final EntityManager em;
	
	public CustomSelectionRepository(EntityManager em) {
		this.em = em;
	}
	
	public List<RegisterModel> findAll(String shop, String zone, String corridor, Date startDate, Date endDate){
		String query = "Select * from public.tb_validade as R ";
		String condicao = "where ";
		
		if(startDate != null && endDate != null) {
			query += condicao + "R.validity between :startDate and :endDate ";
			condicao = "and ";
		}
		
		if(shop != null) {
			query += condicao + "R.shop = :shop ";
			condicao = "and ";
		}
		if(zone != null) {
			query += condicao + "R.zone = :zone ";
			condicao = "and ";
		}
		if(corridor != null) {
			query += condicao + "R.corridor = :corridor ";
			condicao = "and ";
		}
		
		var q = em.createQuery(query, RegisterModel.class);
		
		if(startDate != null && endDate != null) {
			q.setParameter("startDate", startDate);
			q.setParameter("endDate", endDate);
		}
		
		if(shop != null) {
			q.setParameter("shop", shop);
		}
		if(zone != null) {
			q.setParameter("zone", zone);
		}
		if(corridor != null) {
			q.setParameter("corridor", corridor);
		}
		
		return q.getResultList();
	}
}
