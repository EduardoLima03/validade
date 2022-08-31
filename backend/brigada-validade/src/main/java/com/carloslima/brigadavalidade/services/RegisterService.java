package com.carloslima.brigadavalidade.services;

import java.util.Date;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import com.carloslima.brigadavalidade.models.RegisterModel;
import com.carloslima.brigadavalidade.repositories.CustomSelectionRepository;
import com.carloslima.brigadavalidade.repositories.RegisterRepository;

@Service
public class RegisterService {

	private final RegisterRepository registerRepository;
	private final CustomSelectionRepository customSelection ;
	
	public RegisterService(RegisterRepository repository, CustomSelectionRepository custom) {
		this.registerRepository = repository;
		this.customSelection = custom;
	}

	@Transactional
	public RegisterModel save(RegisterModel registerModel) {
		// TODO Auto-generated method stub
		return registerRepository.save(registerModel);
	}
	
	public List<RegisterModel> findAll(){
		return registerRepository.findAll();
	}
	
	public List<RegisterModel> findAllValidityBetween(String shop, String zone, String corridor, Date startDate, Date endDate){
		return customSelection.findAll(shop, zone, corridor, startDate, endDate);
	}
}
