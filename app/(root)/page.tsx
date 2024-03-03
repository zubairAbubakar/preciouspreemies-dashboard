import { Button } from '@/components/ui/button';

export default function Home() {
	return (
		<div className="p-4>
			<Button>Click Me</Button>
			<h3>Button 2</h3>
			<Button variant={'destructive'}>Click Me too</Button>
			<h3>Button 3</h3>
			<Button variant={'ghost'}>Thress</Button>
		</div>
	);
}
