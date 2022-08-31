package com.carloslima.brigadavalidade.dtos;

import javax.validation.constraints.NotBlank;

public class ValidityBetweenDto {

	private String shop;
	private String zone;
	
	private String corridor;
	@NotBlank
	private String dateStart;
	@NotBlank
	private String dateEnd;
	
	public String getDateStart() {
		return dateStart;
	}
	public void setDateStart(String dateStart) {
		this.dateStart = dateStart;
	}
	public String getDateEnd() {
		return dateEnd;
	}
	public void setDateEnd(String dateEnd) {
		this.dateEnd = dateEnd;
	}
	
	public String getShop() {
		return shop;
	}
	public void setShop(String shop) {
		this.shop = shop;
	}
	public String getZone() {
		return zone;
	}
	public void setZone(String zone) {
		this.zone = zone;
	}
	public String getCorridor() {
		return corridor;
	}
	public void setCorridor(String corridor) {
		this.corridor = corridor;
	}
}
