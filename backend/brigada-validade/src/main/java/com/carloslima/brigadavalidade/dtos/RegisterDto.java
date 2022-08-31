package com.carloslima.brigadavalidade.dtos;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

public class RegisterDto {

	@NotBlank
	@Size(max = 13)
	private String ean;
	@NotBlank
	private String description;
	@NotBlank
	private String validity;
	@NotBlank
	private String quantity;
	@NotBlank
	private String shop;
	@NotBlank
	private String zone;
	
	private String corridor;
	
	public String getEan() {
		return ean;
	}
	public void setEan(String ean) {
		this.ean = ean;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getValidity() {
		return validity;
	}
	public void setValidity(String validity) {
		this.validity = validity;
	}
	public String getQuantity() {
		return quantity;
	}
	public void setQuantity(String quantity) {
		this.quantity = quantity;
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
