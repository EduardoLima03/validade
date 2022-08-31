package com.carloslima.brigadavalidade.controllers;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

import javax.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.carloslima.brigadavalidade.dtos.RegisterDto;
import com.carloslima.brigadavalidade.models.RegisterModel;
import com.carloslima.brigadavalidade.services.RegisterService;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;

@RestController
@CrossOrigin(origins = "*", maxAge = 3600)
@RequestMapping("/register")
@JsonDeserialize(using = LocalDateTimeDeserializer.class)
public class RegisterController {

	final RegisterService service;

	public RegisterController(RegisterService registerService) {
		this.service = registerService;
	}

	@PostMapping
	public ResponseEntity<Object> saveRegistor(@RequestBody @Valid RegisterDto registerDto) throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm");
		var registerModel = new RegisterModel();
		// BeanUtils.copyProperties(registerDto, registerModel);
		registerModel.setEan(registerDto.getEan());
		registerModel.setDescription(registerDto.getDescription());
		registerModel.setQuantity(Integer.parseInt(registerDto.getQuantity()));
		registerModel.setShop(registerDto.getShop());
		registerModel.setZone(registerDto.getZone());
		registerModel.setCorridor(registerDto.getCorridor());
		registerModel.setValidity(sdf.parse(registerDto.getValidity()));
		registerModel.setRegistrationDate(LocalDateTime.now(ZoneId.of("UTC")));
		return ResponseEntity.status(HttpStatus.CREATED).body(service.save(registerModel));
	}

	@GetMapping
	public ResponseEntity<List<RegisterModel>> getAllregisters() {
		return ResponseEntity.status(HttpStatus.OK).body(service.findAll());
	}

	@GetMapping("/validity")
	public ResponseEntity<List<RegisterModel>> getAllValidity(
			@RequestParam(value = "shop", required = false) String shop,
			@RequestParam(value = "zone", required = false) String zone,
			@RequestParam(value = "corridor", required = false) String corridor,
			@RequestParam(value = "date_start", required = false) String dateStart,
			@RequestParam(value = "date_end", required = false) String dateEnd) {
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm");
		if (dateEnd != null && dateEnd != null) {
			try {
				return ResponseEntity.status(HttpStatus.OK).body(
						service.findAllValidityBetween(shop, zone, corridor, sdf.parse(dateStart), sdf.parse(dateEnd)));
			} catch (ParseException e) {
				return (ResponseEntity<List<RegisterModel>>) ResponseEntity.status(HttpStatus.BAD_REQUEST);
			}
		} else {
			LocalDate primeiroDiaAno = LocalDate.of(LocalDate.now().getYear(), 1, 1);
			LocalDate ultimoDiaAno = LocalDate.of(LocalDate.now().getYear(), 12, 30);
			try {
				return ResponseEntity.status(HttpStatus.OK).body(service.findAllValidityBetween(shop, zone, corridor,
						sdf.parse(primeiroDiaAno.toString()), sdf.parse(ultimoDiaAno.toString())));
			} catch (ParseException e) {
				return (ResponseEntity<List<RegisterModel>>) ResponseEntity.status(HttpStatus.BAD_REQUEST);
			}

		}
	}
}
