```
npm install react-router-dom
```

React router allows for navigation between pages and component 
react is a single page application SPA, pages are rendered one by one 

# Setting up the routing 
**Main.tsx**
``` javaScript 
import React from 'react';  
import ReactDOM from 'react-dom/client';  
import { BrowserRouter } from 'react-router-dom';  
import App from './App';  
  
ReactDOM.createRoot(document.getElementById('root')!).render(  
	<React.StrictMode>  
		<BrowserRouter>  
			<App />  
		</BrowserRouter>  
	</React.StrictMode>  
);
```

**App.tsx**
```JavaScript 
import { Routes, Route } from 'react-router-dom';  
import Home from './pages/Home';  
import About from './pages/About';  
import BlogList from './pages/BlogList';  
import BlogPost from './pages/BlogPost';  
  
export default function App() {  
return (  
	<Routes>  
		<Route path="/" element={<Home />} />  
		<Route path="/about" element={<About />} />  
		<Route path="/blogs" element={<BlogList />} />  
		<Route path="/blogs/:id" element={<BlogPost />} />  
	</Routes>  
);  
}
```


# Linking 
```
<Link to="/blogs">View Blog Posts</Link>
```