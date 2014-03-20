package org.ironrhino.activiti.form;

import java.math.BigDecimal;

public class DecimalFormType extends NamedFormType {

	public Object convertFormValueToModelValue(String propertyValue) {
		try {
			return new BigDecimal(propertyValue);
		} catch (NumberFormatException e) {
			return null;
		}
	}

}