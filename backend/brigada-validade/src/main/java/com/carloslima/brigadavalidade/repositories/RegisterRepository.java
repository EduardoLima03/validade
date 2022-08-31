package com.carloslima.brigadavalidade.repositories;

import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.carloslima.brigadavalidade.models.RegisterModel;

@Repository
public interface RegisterRepository extends JpaRepository<RegisterModel, UUID>{

	List<RegisterModel> findAllByValidityBetween(Date startDate, Date endDate);
}
