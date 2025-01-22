import * as React from "react";

interface EmailTemplateProps {
	firstName: string;
	otp: number;
}

export const EmailTemplate: React.FC<Readonly<EmailTemplateProps>> = ({
	firstName,
	otp,
}: EmailTemplateProps) => (
	<div>
		<h1>
			Welcome,
			{firstName}
			!
		</h1>
		<p>
			Your OTP is:
			{" "}
			{otp}
		</p>
	</div>
);
